Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbXDKJOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbXDKJOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXDKJOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:14:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:44065 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbXDKJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FaZV9xFjdCeY2Xh3cdDK9iSMNbBi1E9MqkwNQVdNUkLvK4BOXynLpOAOCKV2cZG580qHN6m9p1O2f6i4ZqZgkoHawm2exjBPkDI6yEKcsMSp7GXlz+yTRTb2TJjo10vku2Idj1XHtSAgv0Az8d51kW1cDvStxVAoAMhtoUejSF8=
Message-ID: <ac8af0be0704110214qdca2ee9t3b44a17341e53730@mail.gmail.com>
Date: Wed, 11 Apr 2007 17:14:46 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	 <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I enable CONFIG_DEBUG_SLAB, but don't get any extra debug messages
related to slab.
Is there other switch that I need to turn on?

Thanks,
Forrest

BUG: soft lockup detected on CPU#6!

Call Trace:
 <IRQ>  [<ffffffff800b3834>] softlockup_tick+0xdb/0xed
 [<ffffffff80093edf>] update_process_times+0x42/0x68
 [<ffffffff80074897>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074f59>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005c7c2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80043b09>] invalidate_mapping_pages+0xe1/0x15f
 [<ffffffff80043afa>] invalidate_mapping_pages+0xd2/0x15f
 [<ffffffff800d5bea>] kill_bdev+0xe/0x21
 [<ffffffff800d6110>] __blkdev_put+0x4f/0x169
 [<ffffffff80012785>] __fput+0xae/0x198
 [<ffffffff80023ca6>] filp_close+0x5c/0x64
 [<ffffffff80038e33>] put_files_struct+0x6c/0xc3
 [<ffffffff8001543d>] do_exit+0x2d2/0x8b1
 [<ffffffff80047932>] cpuset_exit+0x0/0x6c
 [<ffffffff8002b30f>] get_signal_to_deliver+0x427/0x456
 [<ffffffff80059b9e>] do_notify_resume+0x9c/0x7a9
 [<ffffffff8008776d>] default_wake_function+0x0/0xe
 [<ffffffff800b2b79>] audit_syscall_exit+0x2cd/0x2ec
 [<ffffffff8005be62>] int_signal+0x12/0x17


On 4/11/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 4/11/07, Zhao Forrest <forrest.zhao@gmail.com> wrote:
> > We're using RHEL5 with kernel version 2.6.18-8.el5.
> > When doing a stress test on raw device for about 3-4 hours, we found
> > the soft lockup message in dmesg.
> > I know we're not reporting the bug on the latest kernel, but does any
> > expert know if this is the known issue in old kernel? Or why
> > kmem_cache_free occupy CPU for more than 10 seconds?
>
> Sounds like slab corruption. CONFIG_DEBUG_SLAB should tell you more.
>
