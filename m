Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZFXF0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZFXF0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZFXF0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:26:33 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41591 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZFXF0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QDCAy+R+B6H5PgimY9WYFBK2yeusVmB2j0Cp930SBVvcoGaHEimest61TDkWbnaBXI
         Ls3VV+8OmW9mOqww//uRxcug5HaDV0PD9vC6JmfGAr6LWnktnt3tZYM+y3KjCp08yzAG
         u+GYp/tP/Z97obFIXRYBr01CiFJ66jCShnG+M=
MIME-Version: 1.0
In-Reply-To: <1245764109.2674.1.camel@localhost>
References: <1245687358-10481-1-git-send-email-jglisse@redhat.com>
	 <4A404049.1080707@mit.edu> <4A40D4D7.9070306@mit.edu>
	 <1245764109.2674.1.camel@localhost>
Date: Wed, 24 Jun 2009 01:26:33 -0400
X-Google-Sender-Auth: 2585b42993735d93
Message-ID: <cb0375e10906232226q682a7d1fvc14e470be93cf5c6@mail.gmail.com>
Subject: Re: [PATCH 1/2] radeon: fix radeon kms framebuffer device
From: Andrew Lutomirski <luto@mit.edu>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Jerome Glisse <jglisse@redhat.com>, airlied@gmail.com,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 9:35 AM, Jerome Glisse<glisse@freedesktop.org> wrote:
> On Tue, 2009-06-23 at 09:12 -0400, Andy Lutomirski wrote:
>> Andy Lutomirski wrote:
>> > Jerome Glisse wrote:
>> >> smem.start is a physical address which kernel can remap to access
>> >> video memory of the fb buffer. We now pin the fb buffer into vram
>> >> by doing so we are loosing vram but fbdev need to be reworked to
>> >> allow change in framebuffer address.
>> >
>> > I tested this (and the corresponding 2/2 initialization order, but
>> > with radeon as a module), and plymouth seems to be fully functional
>> > (graphical boot, password prompt, etc).
>> >
>> > (The driver set the wrong mode, but that's a different issue.)
>> >
>> > Thanks!
>> >
>> > Tested-by: Andy Lutomirski <luto@mit.edu>
>> >
>> Got an oops after awhile:
>>
>> BUG: Bad page state in process gpg-agent  pfn:37dd5
>> page:ffffea0000c38698 flags:200000000050000c count:0 mapcount:0
>> mapping:(null) index:7fd35e311
>> Pid: 3131, comm: gpg-agent Not tainted 2.6.30 #5
>> Call Trace:
>>  [<ffffffff810bc99b>] bad_page+0x115/0x13e
>>  [<ffffffff810bcbd3>] free_pages_check+0x3c/0x6d
>>  [<ffffffff810bde8f>] free_hot_cold_page+0x4e/0x151
>>  [<ffffffff810bdfce>] __pagevec_free+0x3c/0x65
>>  [<ffffffff810c1c82>] release_pages+0x1a5/0x1cb
>>  [<ffffffff810de357>] free_pages_and_swap_cache+0x6d/0x9e
>>  [<ffffffff810d584b>] tlb_finish_mmu+0x41/0x63
>>  [<ffffffff810d5b3f>] exit_mmap+0xfb/0x138
>>  [<ffffffff8104beae>] mmput+0x55/0xc1
>>  [<ffffffff81050626>] exit_mm+0x10e/0x12f
>>  [<ffffffff8105226f>] do_exit+0x1b4/0x6a8
>>  [<ffffffff8106c6b0>] ? up_read+0x1c/0x32
>>  [<ffffffff810527e2>] do_group_exit+0x7f/0xac
>>  [<ffffffff81052834>] sys_exit_group+0x25/0x3d
>>  [<ffffffff8100beab>] system_call_fastpath+0x16/0x1b
>>
>> I don't know if this is related to the drm changes.
>>
>> Back to 2.6.29 for me :)  (I actually use this machine, so I'd rather
>> not run kernels that cause random corruption.)
>>
>> --Andy
>
> Could you get a trace using Linus pte check patch he posted earlier
> on the other thread ?

It didn't trigger Linus' warning.

I was also able to trigger this bug with modesetting turned off on the
kernel command line by switching VTs.

--Andy

>
> Jerome
>
>
