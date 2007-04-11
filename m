Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXDKGRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXDKGRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDKGRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:17:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161218AbXDKGRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CpiEfmI312V1AObpjc4agRtt9YDtTgwNCMCtbfkPmQnkGEu3/NX7QeiCAuT218geAkRLXK2RrQ79za1E/w7rDrj4Tp/yGBrWYgg8WFZTnl/3J+XXwMP36ZzgOs3Hl3X8dHF0oanqqKYapgcqrMGhrUk0VBaZt3xX6+Vb3QYOKfQ=
Message-ID: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
Date: Wed, 11 Apr 2007 14:17:04 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: linux-mm@kvack.org
Subject: Why kmem_cache_free occupy CPU for more than 10 seconds?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We're using RHEL5 with kernel version 2.6.18-8.el5.
When doing a stress test on raw device for about 3-4 hours, we found
the soft lockup message in dmesg.
I know we're not reporting the bug on the latest kernel, but does any
expert know if this is the known issue in old kernel? Or why
kmem_cache_free occupy CPU for more than 10 seconds?

Please let me know if you need any information.

Thanks,
Forrest
--------------------------------------------------------------
BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2c93>] softlockup_tick+0xdb/0xed
 [<ffffffff800933df>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80007660>] kmem_cache_free+0x1c0/0x1cb
 [<ffffffff800262ee>] free_buffer_head+0x2a/0x43
 [<ffffffff80027110>] try_to_free_buffers+0x89/0x9d
 [<ffffffff80043041>] invalidate_mapping_pages+0x90/0x15f
 [<ffffffff800d4a77>] kill_bdev+0xe/0x21
 [<ffffffff800d4f9d>] __blkdev_put+0x4f/0x169
 [<ffffffff80012281>] __fput+0xae/0x198
 [<ffffffff80023647>] filp_close+0x5c/0x64
 [<ffffffff800384f9>] put_files_struct+0x6c/0xc3
 [<ffffffff80014f01>] do_exit+0x2d2/0x8b1
 [<ffffffff80046eb6>] cpuset_exit+0x0/0x6c
 [<ffffffff8002abd7>] get_signal_to_deliver+0x427/0x456
 [<ffffffff80059122>] do_notify_resume+0x9c/0x7a9
 [<ffffffff80086c6d>] default_wake_function+0x0/0xe
 [<ffffffff800b1fd8>] audit_syscall_exit+0x2cd/0x2ec
 [<ffffffff8005b362>] int_signal+0x12/0x17
--------------------------------------------------------------
