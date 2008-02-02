Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbYBBQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbYBBQm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYBBQmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:42:16 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:25970 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYBBQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:42:14 -0500
X-Trace: 660915722/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.9
X-SBRS: None
X-RemoteIP: 81.1.80.9
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGQspEdRAVAJ/2dsb2JhbACBWKt9
Subject: slab cache question
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linux-sh <linux-sh@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 02 Feb 2008 16:41:26 +0000
Message-Id: <1201970486.6253.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been having problems with the slab cache (using slub) in my maple
bus driver (eg see http://lkml.org/lkml/2008/1/28/74).



I have now switched to using SLAB_POISON in kmem_cache_create and
instead of fatal oops, I get what follows - could someone tell me the
likely causes I should be looking for?

[  433.428976] =============================================================================
[  433.430826] BUG maple_queue_cache: Poison overwritten
[  433.430826] -----------------------------------------------------------------------------
[  433.430826] 
[  433.430826] INFO: 0x8cacc000-0x8cacc01f. First byte 0xff instead of 0x6b
[  433.430826] INFO: Slab 0x8c29f980 used=0 fp=0x8cacc000 flags=0x40c2
[  433.430826] INFO: Object 0x8cacc000 @offset=0 fp=0x8cacc420
[  433.430826] 
[  433.430826]   Object 0x8cacc000:  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ����������������
[  433.430826]   Object 0x8cacc010:  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ����������������
[  433.430826]   Object 0x8cacc020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]   Object 0x8cacc030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]   Object 0x8cacc040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]   Object 0x8cacc050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]   Object 0x8cacc060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]   Object 0x8cacc070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  433.430826]  Padding 0x8cacc404:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[  433.430826]  Padding 0x8cacc414:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a             ZZZZZZZZZZZZ    
[  433.430826] Stack: (0x8cc19e50 to 0x8cc1a000)
[  433.430826] 9e40:                                     8c063e0c 8cacc01f 8cacc020 8cacc000 
[  433.430826] 9e60: 8c06403a 000080d0 8cc5f9a0 8c063d80 00000000 8c29f980 8cacc000 8cc79f00 
[  433.430826] 9e80: 8cacc000 0000006b 000003ff 8c064d6a 00000001 8cc79f00 8cacc000 8cc79f70 
[  433.430826] 9ea0: 8c29f980 ffffffff 8c154cc4 8c0117ea 8c064e90 8cc2e290 8cc5f9a0 00000001 
[  433.430826] 9ec0: 8cc79f70 8c064e60 000080d0 00000000 8cc79f70 8c154cc4 00000002 8c064e60 
[  433.430826] 9ee0: 8cb03720 8cb44e00 8c155480 00000000 8c2540ac 00000002 8cc2e200 00000000 
[  433.430826] 9f00: 00000002 00000002 8c029656 00000000 8c018700 fffffffe 8c155300 ffffff0f 
[  433.430826] 9f20: 8cc01300 8c25409c 8c0297a4 8c02d800 8c0295a0 8c02d9c0 8c02d260 8cc01308 
[  433.430826] 9f40: 8cc01300 00000000 8cc0e9c0 8c02da60 8cc19f50 8cc19f50 00000000 8cc0e9c0 
[  433.430826] 9f60: 8c02da60 8cc19f50 8cc19f50 8c02d2b6 00000000 fffffffc 8c0135c0 8c029720 
[  433.430826] 9f80: 8cc01300 8c02d260 8c003844 00000000 00000000 00000000 00000000 00000000 
[  433.430826] 9fa0: 00000000 00000000 00000000 00000000 8cc11ed4 8c02d280 00000000 00000000 
[  433.430826] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 8cc19fa0 
[  433.430826] 9fe0: 8c003840 00000000 40000000 00000000 00000000 00000000 00000000 00000000 
[  433.430826] 
[  433.430826] Call trace: 
[  433.430826] [<8c06403a>] check_object+0xba/0x200
[  433.430826] [<8c063d80>] check_bytes_and_report+0x0/0xe0
[  433.430826] [<8c064d6a>] __slab_alloc+0x40a/0x500
[  433.430826] [<8c154cc4>] maple_alloc_dev+0x44/0xa0
[  433.430826] [<8c0117ea>] update_curr+0x4a/0xe0
[  433.430826] [<8c064e90>] kmem_cache_alloc+0x30/0xc0
[  433.430826] [<8c064e60>] kmem_cache_alloc+0x0/0xc0
[  433.430826] [<8c154cc4>] maple_alloc_dev+0x44/0xa0
[  433.430826] [<8c064e60>] kmem_cache_alloc+0x0/0xc0
[  433.430826] [<8c155480>] maple_dma_handler+0x180/0x2e0
[  433.430826] [<8c029656>] run_workqueue+0xb6/0x180
[  433.430826] [<8c018700>] printk+0x0/0x20
[  433.430826] [<8c155300>] maple_dma_handler+0x0/0x2e0
[  433.430826] [<8c0297a4>] worker_thread+0x84/0xe0
[  433.430826] [<8c02d800>] prepare_to_wait+0x0/0xe0
[  433.430826] [<8c0295a0>] run_workqueue+0x0/0x180
[  433.430826] [<8c02d9c0>] finish_wait+0x0/0xa0
[  433.430826] [<8c02d260>] kthread_should_stop+0x0/0x20
[  433.430826] [<8c02da60>] autoremove_wake_function+0x0/0x40
[  433.430826] [<8c02da60>] autoremove_wake_function+0x0/0x40
[  433.430826] [<8c02d2b6>] kthread+0x36/0x80
[  433.430826] [<8c0135c0>] complete+0x0/0xc0
[  433.430826] [<8c029720>] worker_thread+0x0/0xe0
[  433.430826] [<8c02d260>] kthread_should_stop+0x0/0x20
[  433.430826] [<8c003844>] kernel_thread_helper+0x4/0x20
[  433.430826] [<8c02d280>] kthread+0x0/0x80
[  433.430826] [<8c003840>] kernel_thread_helper+0x0/0x20
[  433.430826] 
[  433.430826] FIX maple_queue_cache: Restoring 0x8cacc000-0x8cacc01f=0x6b
[  433.430826] 
[  433.430826] FIX maple_queue_cache: Marking all objects used
[  433.474526] Maple bus at (0, 2): Connected function 0x10
[  433.474865] No maple driver found for this device

