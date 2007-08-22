Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXHVAZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXHVAZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXHVAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:25:09 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:51971 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbXHVAZG (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:25:06 -0400
Subject: [LOCKDEP][2.6.23-rc2-rt]
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: RT Users List <linux-rt-users@vger.kernel.org>,
       LKML <Linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Tue, 21 Aug 2007 17:25:01 -0700
Message-Id: <1187742301.21808.61.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

here is a lockdep trace I just encountered in the latest rt patch series.

(which has gotten a bit stale, btw.)

Enjoy,

Sven

                                                                                
=====================================                                           
[ BUG: bad unlock balance detected! ]                                           
-------------------------------------                                           
swapper/1 is trying to release lock (per_cpu_lock__slab_irq_locks_locked) at:   
[<ffffffff802b8d24>] kmem_cache_alloc+0xb4/0x150                                
but there are no more locks to release!                                         
                                                                                
other info that might help us debug this:                                       
1 lock held by swapper/1:                                                       
 #0:  (per_cpu_lock__slab_irq_locks_locked#7){--..}, at: [<ffffffff802b7a24>] c0
                                                                                
stack backtrace:                                                                
                                                                                
Call Trace:                                                                     
 [<ffffffff802620c7>] print_unlock_inbalance_bug+0xf7/0x100                     
 [<ffffffff802653d1>] lock_release_non_nested+0x111/0x1a0                       
 [<ffffffff802b8d24>] kmem_cache_alloc+0xb4/0x150                               
 [<ffffffff80265532>] lock_release+0xd2/0x1f0                                   
 [<ffffffff8048cc16>] rt_spin_unlock+0x26/0x40                                  
 [<ffffffff802b8d24>] kmem_cache_alloc+0xb4/0x150                               
 [<ffffffff8034adbc>] kobject_uevent_env+0x13c/0x520                            
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803d8f59>] get_bus+0x9/0x40                                          
 [<ffffffff8034b1b0>] kobject_uevent+0x10/0x20                                  
 [<ffffffff803d79f6>] device_add+0x516/0x680                                    
 [<ffffffff803d7b7e>] device_register+0x1e/0x30                                 
 [<ffffffff803d821c>] device_create+0xec/0x130                                  
 [<ffffffff8034fc5d>] sprintf+0x6d/0x70                                         
 [<ffffffff8027b45b>] add_preempt_count+0x2b/0x150                              
 [<ffffffff80260df3>] put_lock_stats+0x13/0x40                                  
 [<ffffffff80260e8b>] lock_release_holdtime+0x6b/0x90                           
 [<ffffffff80263740>] mark_held_locks+0x10/0x90                                 
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff803af594>] tty_register_device+0x74/0x100                            
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803b0aec>] tty_register_driver+0x16c/0x2a0                           
 [<ffffffff808981be>] pty_init+0x22e/0x570                                      
 [<ffffffff80879b64>] kernel_init+0x194/0x490                                   
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff80263740>] mark_held_locks+0x10/0x90                                 
 [<ffffffff8048c5e8>] trace_hardirqs_on_thunk+0x3a/0x3c                         
 [<ffffffff80263957>] trace_hardirqs_on_caller+0xd7/0x170                       
 [<ffffffff8020d2f8>] child_rip+0xa/0x12                                        
 [<ffffffff8020c9e0>] restore_args+0x0/0x30                                     
 [<ffffffff808799d0>] kernel_init+0x0/0x490                                     
 [<ffffffff8020d2ee>] child_rip+0x0/0x12                                        
                                                                                
INFO: lockdep is turned off.                                                    
---------------------------                                                     
| preempt count: 00000000 ]                                                     
| 0-level deep critical section nesting:                                        
----------------------------------------                                        
                                                                                
------------[ cut here ]------------                                            
kernel BUG at kernel/rtmutex.c:682!                                             
invalid opcode: 0000 [1] PREEMPT SMP                                            
CPU 6                                                                           
Modules linked in:                                                              
Pid: 1, comm: swapper Not tainted 2.6.23-rc2-rt1-debug #1                       
RIP: 0010:[<ffffffff8048c0d4>]  [<ffffffff8048c0d4>] rt_spin_lock_slowlock+0x1b0
RSP: 0018:ffff81041d837a10  EFLAGS: 00010046                                    
RAX: ffff81031d836040 RBX: ffff81032c1542a0 RCX: 00000000ffffffff               
RDX: ffff81031d836040 RSI: ffff81032c1542b8 RDI: ffff81032c1542a0               
RBP: ffff81041d837ad0 R08: 0000000000000002 R09: 0000000000000001               
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000246               
R13: 00000000000080d0 R14: ffff81011b9009c0 R15: ffffffff805606b4               
FS:  0000000000000000(0000) GS:ffff81041d8ef3c0(0000) knlGS:0000000000000000    
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                               
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0               
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000               
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400               
Process swapper (pid: 1, threadinfo ffff81041d836000, task ffff81031d836040)    
Stack:  111111110000008c ffff81041d837a18 ffff81041d837a18 ffff81041d837a28     
 ffff81041d837a28 0000000000000000 111111110000008c ffff81041d837a48            
 ffff81041d837a48 ffff81041d837a58 ffff81041d837a58 0000000000000000            
Call Trace:                                                                     
 [<ffffffff8048cb1d>] __rt_spin_lock+0x3d/0x50                                  
 [<ffffffff8048ccf8>] rt_spin_lock+0x58/0x70                                    
 [<ffffffff802b81eb>] __kmalloc+0x9b/0x1c0                                      
 [<ffffffff8034a62e>] kobject_get_path+0x7e/0xf0                                
 [<ffffffff8034ade3>] kobject_uevent_env+0x163/0x520                            
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803d8f59>] get_bus+0x9/0x40                                          
 [<ffffffff8034b1b0>] kobject_uevent+0x10/0x20                                  
 [<ffffffff803d79f6>] device_add+0x516/0x680                                    
 [<ffffffff803d7b7e>] device_register+0x1e/0x30                                 
 [<ffffffff803d821c>] device_create+0xec/0x130                                  
 [<ffffffff8034fc5d>] sprintf+0x6d/0x70                                         
 [<ffffffff8027b45b>] add_preempt_count+0x2b/0x150                              
 [<ffffffff80260df3>] put_lock_stats+0x13/0x40                                  
 [<ffffffff80260e8b>] lock_release_holdtime+0x6b/0x90                           
 [<ffffffff80263740>] mark_held_locks+0x10/0x90                                 
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff803af594>] tty_register_device+0x74/0x100                            
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803b0aec>] tty_register_driver+0x16c/0x2a0                           
 [<ffffffff808981be>] pty_init+0x22e/0x570                                      
 [<ffffffff80879b64>] kernel_init+0x194/0x490                                   
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff80263740>] mark_held_locks+0x10/0x90                                 
 [<ffffffff8048c5e8>] trace_hardirqs_on_thunk+0x3a/0x3c                         
 [<ffffffff80263957>] trace_hardirqs_on_caller+0xd7/0x170                       
 [<ffffffff8020d2f8>] child_rip+0xa/0x12                                        
 [<ffffffff8020c9e0>] restore_args+0x0/0x30                                     
 [<ffffffff808799d0>] kernel_init+0x0/0x490                                     
 [<ffffffff8020d2ee>] child_rip+0x0/0x12                                        
                                                                                
INFO: lockdep is turned off.                                                    
---------------------------                                                     
| preempt count: 00000001 ]                                                     
| 1-level deep critical section nesting:                                        
----------------------------------------                                        
.. [<ffffffff8048db6f>] .... __spin_lock_irqsave+0x2f/0x90                      
.....[<ffffffff8048bf58>] ..   ( <= rt_spin_lock_slowlock+0x38/0x220)           
                                                                                
                                                                                
Code: 0f 0b eb fe 49 89 f4 45 31 ff 66 90 e9 1b ff ff ff 48 8d 53               
RIP  [<ffffffff8048c0d4>] rt_spin_lock_slowlock+0x1b4/0x220                     
 RSP <ffff81041d837a10>                                                         
Kernel panic - not syncing: Attempted to kill init!                             
                                                                                
Call Trace:                                                                     
 [<ffffffff8023f2f4>] panic+0xb4/0x190                                          
 [<ffffffff80261ef7>] print_lock_contention_bug+0x27/0x100                      
 [<ffffffff8024f1f1>] __blocking_notifier_call_chain+0x21/0x80                  
 [<ffffffff8024f266>] blocking_notifier_call_chain+0x16/0x20                    
 [<ffffffff80243d1c>] do_exit+0xa1c/0xa20                                       
 [<ffffffff8048be14>] rt_spin_lock_slowunlock+0x54/0x90                         
 [<ffffffff8023f029>] do_oops_enter_exit+0x9/0xe0                               
 [<ffffffff8020de2a>] die+0x5a/0x80                                             
 [<ffffffff8048f5f1>] do_trap+0x131/0x140                                       
 [<ffffffff8020e3a5>] do_invalid_op+0x95/0xb0                                   
 [<ffffffff8048c0d4>] rt_spin_lock_slowlock+0x1b4/0x220                         
 [<ffffffff802640b6>] __lock_acquire+0x16/0x1150                                
 [<ffffffff803514d9>] debug_locks_off+0x9/0x90                                  
 [<ffffffff8048a236>] thread_return+0xac/0xb56                                  
 [<ffffffff8048ec7d>] error_exit+0x0/0x96                                       
 [<ffffffff8048c0d4>] rt_spin_lock_slowlock+0x1b4/0x220                         
 [<ffffffff8048cb1d>] __rt_spin_lock+0x3d/0x50                                  
 [<ffffffff8048ccf8>] rt_spin_lock+0x58/0x70                                    
 [<ffffffff802b81eb>] __kmalloc+0x9b/0x1c0                                      
 [<ffffffff8034a62e>] kobject_get_path+0x7e/0xf0                                
 [<ffffffff8034ade3>] kobject_uevent_env+0x163/0x520                            
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803d8f59>] get_bus+0x9/0x40                                          
 [<ffffffff8034b1b0>] kobject_uevent+0x10/0x20                                  
 [<ffffffff803d79f6>] device_add+0x516/0x680                                    
 [<ffffffff803d7b7e>] device_register+0x1e/0x30                                 
 [<ffffffff803d821c>] device_create+0xec/0x130                                  
 [<ffffffff8034fc5d>] sprintf+0x6d/0x70                                         
 [<ffffffff8027b45b>] add_preempt_count+0x2b/0x150                              
 [<ffffffff80260df3>] put_lock_stats+0x13/0x40                                  
 [<ffffffff80260e8b>] lock_release_holdtime+0x6b/0x90                           
 [<ffffffff80263740>] mark_held_locks+0x10/0x90                                 
 [<ffffffff802639fd>] trace_hardirqs_on+0xd/0x10                                
 [<ffffffff803af594>] tty_register_device+0x74/0x100                            
 [<ffffffff8048bea4>] rt_mutex_slowunlock+0x54/0x90                             
 [<ffffffff803b0aec>] tty_register_driver+0x16c/0x2a0                           

