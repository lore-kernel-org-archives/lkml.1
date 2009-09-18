Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZIRUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZIRUQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZIRUQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:16:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIRUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:16:48 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090918183203.GG23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
	 <20090917194027.GS23126@kernel.dk>
	 <1253229410.2783.16.camel@heimdal.trondhjem.org>
	 <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk>
	 <1253290790.3183.14.camel@heimdal.trondhjem.org>
	 <20090918173608.GD23126@kernel.dk>  <20090918183203.GG23126@kernel.dk>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 22:16:43 +0200
Message-Id: <1253305003.10538.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> Peter, if you have
> the time, it would be nice if you could check whether this one works for
> you too.

Doesn't make my machine happy :/

Mounting NFS filesystems:  [   18.616780] RPC: Registered udp transport module.                                
[   18.622141] RPC: Registered tcp transport module.                                                           
[   18.932802] ------------[ cut here ]------------                                                            
[   18.937461] WARNING: at /mnt/build/linux-2.6/fs/sysfs/dir.c:487 sysfs_add_one+0xf8/0x10f()                  
[   18.945729] Hardware name: To Be Filled By O.E.M.                                                           
[   18.950444] sysfs: cannot create duplicate filename '/class/bdi/0:0'                                        
[   18.956801] Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput floppy sg button serio_raw pcspkr sr_mod cdrom shpchp [last unloaded: scsi_wait_scan]                              
[   18.974129] Pid: 1285, comm: mount.nfs Not tainted 2.6.31-tip #15                                           
[   18.980227] Call Trace:                                                                                     
[   18.982691]  [<ffffffff81150b8e>] ? sysfs_add_one+0xf8/0x10f                                                
[   18.988366]  [<ffffffff8104d009>] warn_slowpath_common+0x7c/0xa9                                            
[   18.994384]  [<ffffffff8104d0b5>] warn_slowpath_fmt+0x69/0x6b                                               
[   19.000459]  [<ffffffff8107959b>] ? trace_hardirqs_on_caller+0x10b/0x12f                                    
[   19.007167]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.012837]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.018507]  [<ffffffff81150a8e>] ? sysfs_pathname+0x3c/0x44                                                
[   19.024175]  [<ffffffff81150b8e>] sysfs_add_one+0xf8/0x10f                                                  
[   19.029671]  [<ffffffff81151214>] create_dir+0x5d/0x98                                                      
[   19.034822]  [<ffffffff8115128c>] sysfs_create_dir+0x3d/0x54                                                
[   19.040486]  [<ffffffff8136378b>] ? _spin_unlock+0x35/0x50                                                  
[   19.045974]  [<ffffffff811bd4f5>] kobject_add_internal+0xdb/0x19b                                           
[   19.052066]  [<ffffffff811bd68d>] kobject_add_varg+0x41/0x4e                                                
[   19.057725]  [<ffffffff811bd79f>] kobject_add+0x89/0x8b                                                     
[   19.062951]  [<ffffffff8107933a>] ? mark_held_locks+0x4d/0x6b                                               
[   19.068695]  [<ffffffff81077f80>] ? lockdep_init_map+0xae/0x510                                             
[   19.074612]  [<ffffffff811bd394>] ? kobject_get+0x1a/0x22                                                   
[   19.080010]  [<ffffffff8123ba40>] ? get_device+0x19/0x1f                                                    
[   19.085320]  [<ffffffff8123c3ea>] device_add+0xe4/0x5d8                                                     
[   19.090548]  [<ffffffff811c7641>] ? __spin_lock_init+0x31/0x54                                              
[   19.096379]  [<ffffffff8123c8fc>] device_register+0x1e/0x22                                                 
[   19.101951]  [<ffffffff8123ca13>] device_create_vargs+0x113/0x140                                           
[   19.108044]  [<ffffffff810d96ae>] bdi_register+0x85/0x197                                                   
[   19.113443]  [<ffffffff8107959b>] ? trace_hardirqs_on_caller+0x10b/0x12f                                    
[   19.120140]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.125539]  [<ffffffff811ca0cc>] ? __percpu_counter_init+0x9b/0xa7                                         
[   19.131803]  [<ffffffff811bf15b>] ? prop_local_init_percpu+0x43/0x48                                        
[   19.138158]  [<ffffffff810d97e8>] bdi_register_dev+0x28/0x2a                                                
[   19.143838]  [<ffffffffa0143b83>] nfs_set_super+0x42/0x98 [nfs]                                             
[   19.149756]  [<ffffffff810f8d36>] sget+0x3bc/0x490                                                          
[   19.154562]  [<ffffffffa0143b41>] ? nfs_set_super+0x0/0x98 [nfs]                                            
[   19.160580]  [<ffffffffa01434d8>] ? nfs_compare_super+0x0/0x183 [nfs]                                       
[   19.167031]  [<ffffffffa01450cd>] nfs_get_sb+0x806/0xae6 [nfs]                                              
[   19.172863]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   19.178268]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[   19.183752]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[   19.189325]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[   19.194724]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[   19.199863]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[   19.205695]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[   19.210746]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[   19.217185]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[   19.223188] ---[ end trace 40613bb406b77053 ]---   

And later..

[   79.141208] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008                       
[   79.142055] IP: [<ffffffff810d9572>] bdi_destroy+0x70/0x127                                                 
[   79.142055] PGD 0                                                                                           
[   79.142055] Oops: 0002 [#1] PREEMPT SMP                                                                     
[   79.142055] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/irq                                       
[   79.142055] CPU 0                                                                                           
[   79.142055] Modules linked in: nfsd exportfs autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand kvm_amd kvm uinput floppy sg button serio_raw pcspkr sr_mod cdrom shpchp [last unloaded: scsi_wait_scan]        
[   79.142055] Pid: 1622, comm: mount.nfs Tainted: G        W  2.6.31-tip #15 To Be Filled By O.E.M.           
[   79.142055] RIP: 0010:[<ffffffff810d9572>]  [<ffffffff810d9572>] bdi_destroy+0x70/0x127                     
[   79.142055] RSP: 0018:ffff88007d08db38  EFLAGS: 00010213                                                    
[   79.142055] RAX: 0000000000000000 RBX: ffff88007e5fa848 RCX: 0000000000000000                               
[   79.142055] RDX: ffffffff815651d0 RSI: ffffffff815671b8 RDI: ffffffff810d9551                               
[   79.142055] RBP: ffff88007d08db48 R08: ffff880005dda080 R09: 0000000000000000                               
[   79.142055] R10: 0000000000000246 R11: ffffffff81566960 R12: ffff88007e5faa58                               
[   79.142055] R13: ffff88007e557a00 R14: ffff88007e560000 R15: ffff88007e0c5980                               
[   79.142055] FS:  00007f529fce36f0(0000) GS:ffff880005c00000(0000) knlGS:0000000000000000                    
[   79.142055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                               
[   79.142055] CR2: 0000000000000008 CR3: 000000007e580000 CR4: 00000000000006f0                               
[   79.142055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                               
[   79.142055] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                               
[   79.142055] Process mount.nfs (pid: 1622, threadinfo ffff88007d08c000, task ffff88007e17c440)               
[   79.142055] Stack:                                                                                          
[   79.142055]  ffff88007e5fa800 ffffffffffffff8c ffff88007d08db68 ffffffffa0139795                            
[   79.142055] <0> ffff88007e560000 00000000ffffff8c ffff88007d08dcc8 ffffffffa013a65d                         
[   79.142055] <0> ffff88007d08dbf8 ffffffffa00d1b15 ffff880000000000 ffff88007e17c440                         
[   79.142055] Call Trace:                                                                                     
[   79.142055]  [<ffffffffa0139795>] nfs_free_server+0xea/0x112 [nfs]                                          
[   79.142055]  [<ffffffffa013a65d>] nfs_create_server+0x5ca/0x5e1 [nfs]                                       
[   79.142055]  [<ffffffffa00d1b15>] ? rpc_shutdown_client+0xdb/0xea [sunrpc]                                  
[   79.142055]  [<ffffffffa00d1827>] ? rpc_call_sync+0x59/0x62 [sunrpc]                                        
[   79.142055]  [<ffffffffa014d8d2>] ? nfs_mount+0x128/0x1ab [nfs]                                             
[   79.142055]  [<ffffffff810795cc>] ? trace_hardirqs_on+0xd/0xf                                               
[   79.142055]  [<ffffffffa014508b>] nfs_get_sb+0x7c4/0xae6 [nfs]                                              
[   79.142055]  [<ffffffff81361902>] ? mutex_unlock+0xe/0x10                                                   
[   79.142055]  [<ffffffff810f4b98>] ? pcpu_alloc+0x68c/0x704                                                  
[   79.142055]  [<ffffffff810f914f>] vfs_kern_mount+0x9e/0x122                                                 
[   79.142055]  [<ffffffff810f923a>] do_kern_mount+0x4c/0xec                                                   
[   79.142055]  [<ffffffff8111051b>] do_mount+0x748/0x7ae                                                      
[   79.142055]  [<ffffffff810cc051>] ? __get_free_pages+0x17/0x54                                              
[   79.142055]  [<ffffffff81110605>] sys_mount+0x84/0xbf                                                       
[   79.142055]  [<ffffffff8136317f>] ? trace_hardirqs_on_thunk+0x3a/0x3f                                       
[   79.142055]  [<ffffffff8100bc9b>] system_call_fastpath+0x16/0x1b                                            
[   79.142055] Code: c7 a0 71 56 81 e8 cf a3 28 00 48 8b 8b 10 02 00 00 4c 39 e1 74 24 48 8b 15 6c bc 48 00 48 8b 83 18 02 00 00 48 89 0d 5e bc 48 00 <48> c7 41 08 d0 51 56 81 48 89 10 48 89 42 08 48 8b 8b 20 02 00        
[   79.142055] RIP  [<ffffffff810d9572>] bdi_destroy+0x70/0x127                                                
[   79.142055]  RSP <ffff88007d08db38>                                                                         
[   79.142055] CR2: 0000000000000008                                                                           
[   79.441896] ---[ end trace 40613bb406b77055 ]--- 

