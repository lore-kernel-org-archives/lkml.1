Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZJMLKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZJMLKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbZJMLKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:10:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12904 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759352AbZJMLKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=W3sCGR98OGrY+xHox4cShNyRE71U+UWsGF9SkLoJx9wgndH1QT7Zlj++pdBYT0mtLL
         Msv4u3axKbF5twp7gNBgPiu1SDlT1JDPgBpFzBMyQ6f1DkdJ5rfbQtj1VA7ADF9bfEBg
         qeFs9RCeTuHSeWdydGHNg4eQG5LHd+66gR4hA=
MIME-Version: 1.0
In-Reply-To: <20091013010518.GA2606@mit.edu>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
	 <20091012222910.GB18195@mit.edu>
	 <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
	 <20091012231211.GC18195@mit.edu>
	 <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com>
	 <20091013010518.GA2606@mit.edu>
Date: Tue, 13 Oct 2009 14:08:25 +0300
Message-ID: <94a0d4530910130408q2e0f488dlf982986ebb766789@mail.gmail.com>
Subject: Re: Weird ext4 bug: 256P used?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 4:05 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Oct 13, 2009 at 02:27:48AM +0300, Felipe Contreras wrote:
>>
>> stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
>>   File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586'
>>   Size: 4096          Blocks: 281470681743368 IO Block: 4096   directory
>> Device: fe00h/65024d  Inode: 141257      Links: 2
>> Access: (0755/drwxr-xr-x)  Uid: (4294901760/ UNKNOWN)   Gid: (16711680/ UNKNOWN)
>> Access: 2009-10-12 16:36:22.326920328 +0300
>> Modify: 2009-07-27 20:52:23.000000000 +0300
>> Change: 2009-07-27 20:52:23.000000000 +0300
>
> OK, I see what's going on.   i_blocks_hi is getting set to 0xFFFF.
>
> So I definitely see the bug in e2fsck in not reporitng and fixing the
> problem (and I'll fix that).  I'm not sure how i_blocks_hi got set to
> that value, though; it looks like everything should be doing the right
> thing in the latest mainline kernel.  What version of the kernel are
> you using?

I was using F11 kernels, and at some point I went back to compile my
own kernels. I think I started with 2.6.31 and now 2.6.31.1.

-- 
Felipe Contreras
