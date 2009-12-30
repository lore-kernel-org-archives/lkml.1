Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbZL3Tz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbZL3Tz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZL3Tz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:55:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZL3Tz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:55:56 -0500
Date: Wed, 30 Dec 2009 20:55:55 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: BFS v0.313 CPU scheduler for 2.6.32
Message-ID: <20091230195555.GA5367@fancy-poultry.org>
References: <200912301900.29578.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200912301900.29578.mboton@gmail.com>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091213 (GNU/Linux)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX18r6p1t1H2ZUYfYMPw8GadXXlIDxmMb9EOgOB7
 XfjZCHFT14AAqr4uRAr3OQOGfIOfLsxwy1iEKPoFtHAYJiZ6MC
 ZRCSAxEshgCx24+OEKL/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.12.2009, Miguel Botón wrote: 

> If you want to try BFS on a 2.6.33 kernel, you can try this 'unofficial' port:
> http://git.zen-kernel.org/?p=kernel/zen.git;a=shortlog;h=refs/heads/sched-bfs
 
> I'm currently using it with no issues so far.

Your patch applies cleanly to 2.6.33-rc2, but compilation fails:

[....]
In file included from kernel/sched.c:2:
kernel/sched_bfs.c: In function '__sched_setscheduler':
kernel/sched_bfs.c:3484: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type
kernel/sched_bfs.c:3493: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type
kernel/sched_bfs.c:3509: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type
kernel/sched_bfs.c: In function 'sys_sched_yield':
kernel/sched_bfs.c:3846: warning: passing argument 1 of '_raw_spin_unlock' from incompatible pointer type
kernel/sched_bfs.c: At top level:
kernel/sched_bfs.c:6018: error: conflicting types for 'partition_sched_domains'
include/linux/sched.h:1025: error: previous declaration of 'partition_sched_domains' was here
kernel/sched_bfs.c: In function 'sched_init':
kernel/sched_bfs.c:6425: warning: passing argument 2 of 'plist_head_init' from incompatible pointer type
kernel/sched_bfs.c: In function 'normalize_rt_tasks':
kernel/sched_bfs.c:6499: warning: passing argument 1 of 'spinlock_check' from incompatible pointer type
kernel/sched_bfs.c:6513: warning: passing argument 1 of 'spin_unlock_irqrestore' from incompatible pointer type
make[1]: *** [kernel/sched.o] Error 1
make[1]: *** Waiting for unfinished jobs....
  CC      arch/x86/kernel/alternative.o
  CC      fs/open.o
[....]

[....]
 CC      arch/x86/kernel/init_task.o
  LDS     arch/x86/kernel/vmlinux.lds
  CC [M]  arch/x86/kernel/msr.o
  CC [M]  arch/x86/kernel/cpuid.o
  CC [M]  arch/x86/kernel/microcode_core.o
  CC [M]  arch/x86/kernel/microcode_amd.o
arch/x86/kernel/init_task.c:31: warning: missing braces around initializer
arch/x86/kernel/init_task.c:31: warning: (near initialization for 'init_task.pi_lock')
arch/x86/kernel/init_task.c:31: error: incompatible types in initialization
arch/x86/kernel/init_task.c:31: error: initializer element is not constant
arch/x86/kernel/init_task.c:31: error: (near initialization for 'init_task.dirties.lock')
arch/x86/kernel/init_task.c:31: error: initializer element is not constant
arch/x86/kernel/init_task.c:31: error: (near initialization for 'init_task.perf_event_mutex.wait_lock')
make[2]: *** [arch/x86/kernel/init_task.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2
liesel:/usr/src/linux-2.6.33-rc2 # 

