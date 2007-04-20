Return-Path: <linux-kernel-owner+w=401wt.eu-S2993050AbXDTLdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993050AbXDTLdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993034AbXDTLdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:33:49 -0400
Received: from 85-126-107-146.static.sdsl-line.inode.at ([85.126.107.146]:3776
	"EHLO mail.contec.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993006AbXDTLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:33:48 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 07:33:47 EDT
From: Manfred Gruber <m.gruber@tirol.com>
To: linux-kernel@vger.kernel.org
Subject: preempt_rt bug or warn on arm v4t
Date: Fri, 20 Apr 2007 13:06:08 +0200
User-Agent: KMail/1.6.2
MIME-Version: 1.0
Content-Disposition: inline
Cc: jan.altenberg@linutronix.de, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200704201306.08066.m.gruber@tirol.com>
X-OriginalArrivalTime: 20 Apr 2007 11:05:33.0843 (UTC) FILETIME=[D1239E30:01C7833B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I am using 2.6.21-rc7 with Preempt_rt Patch 2.6.20-rc6-rt0 on ep93xx.
This oops does not trigger in preempt_rt patch is applied. 

On startup i get following oops when preemption is none.

Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
BUG: at kernel/sched.c:4285 __schedule()
[<c006d404>] (dump_stack+0x0/0x14) from [<c02eeea4>] (__schedule+0x844/0x8e0)
[<c02ee660>] (__schedule+0x0/0x8e0) from [<c02ef038>] (schedule+0xd0/0x118)
[<c02eef68>] (schedule+0x0/0x118) from [<c02ef3e0>] 
(wait_for_completion+0x94/0xf0)
 r4 = C042DE88 
[<c02ef34c>] (wait_for_completion+0x0/0xf0) from [<c0099c14>] 
(keventd_create_kthread+0x3c/0x74)
 r7 = 00000000  r6 = 00000002  r5 = C042DED4  r4 = C042DF18
[<c0099bd8>] (keventd_create_kthread+0x0/0x74) from [<c0099ccc>] 
(kthread_create+0x80/0xc8)
 r6 = C001C320  r5 = C042DED4  r4 = 00000000 
[<c0099c4c>] (kthread_create+0x0/0xc8) from [<c009ad48>] 
(posix_cpu_thread_call+0x40/0xb8)
 r3 = 00000000  r2 = C0352BD0 
 r5 = 00000000  r4 = 00000000 
[<c009ad08>] (posix_cpu_thread_call+0x0/0xb8) from [<c000dd10>] 
(posix_cpu_thread_init+0x24/0x40)
 r5 = 00000000  r4 = C03A7F74 
[<c000dcec>] (posix_cpu_thread_init+0x0/0x40) from [<c00088b0>] 
(init+0x38/0x30c)
 r4 = 00000000 
[<c0008878>] (init+0x0/0x30c) from [<c0087b90>] (do_exit+0x0/0x80c)
NET: Registered protocol family 16
ep93xx: PLL1 running at 400 MHz, PLL2 at 192 MHz
ep93xx: FCLK 200 MHz, HCLK 100 MHz, PCLK 50 MHz
SCSI subsystem initialized
usbcore: registered new interface driver usbfs


If I enable full preemp_rt i get a warn:

irq event stamp: 0                                                                                                                                                                                              
hardirqs last  enabled at (0): [<00000000>] __init_begin+0x3fff8000/0x30                                                                                                                                        
hardirqs last disabled at (0): [<c00850f4>] copy_process+0x344/0x124c                                                                                                                                           
softirqs last  enabled at (0): [<c00850f4>] copy_process+0x344/0x124c                                                                                                                                           
softirqs last disabled at (0): [<00000000>] __init_begin+0x3fff8000/0x30                                                                                                                                        
BUG: at kernel/sched.c:4288 __schedule()                                                                                                                                                                        
[<c006e71c>] (dump_stack+0x0/0x28) from [<c0308b64>] (__schedule+0xa04/0xab4)                                                                                                                                   
[<c0308160>] (__schedule+0x0/0xab4) from [<c0308e28>] (schedule+0xdc/0x128)                                                                                                                                     
[<c0308d4c>] (schedule+0x0/0x128) from [<c009d760>] (kthread+0xcc/0x12c)                                                                                                                                        
 r4 = C0B72000                                                                                                                                                                                                  
[<c009d694>] (kthread+0x0/0x12c) from [<c008a508>] (do_exit+0x0/0x814)                                                                                                                                          
 r7 = 00000000  r6 = 00000000  r5 = 00000000  r4 = 00000000                                                                                                                                                     
---------------------------                                                                                                                                                                                     
| preempt count: 00000000 ]                                                                                                                                                                                     
| 0-level deep critical section nesting:                   

Does someone has an idea what is wrong ?

The configs can be found here:
https://dev.contec.at/dev/micro/micro9/LINUX/trunk/kernel/linux-2.6-config/

My quilt queue can be found here:
https://dev.contec.at/dev/micro/micro9/LINUX/trunk/kernel/linux-2.6/patches/

thanks regards
manfred 
