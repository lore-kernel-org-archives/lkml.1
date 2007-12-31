Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXLaQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXLaQfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXLaQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:35:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXLaQfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:35:31 -0500
Date: Mon, 31 Dec 2007 11:35:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20071231163510.GC27060@redhat.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071228142739.GA4560@redhat.com> <20071229054113.GB17426@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071229054113.GB17426@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 11:11:13AM +0530, Dhaval Giani wrote:
> On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> > On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > > Hi Vivek,
> > > 
> > > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > > kexec. It just gets stuck at "Starting new kernel".
> > > 
> > > It does boot normally when booted as the first kernel.
> > > 
> > > Any hints debugging? (x86 architecture)
> > 
> > I generally try few things.
> > 
> > - Specify earlyprintk= parameter for second kernel and see if control
> >   is reaching to second kernel.
> > 
> > - Otherwise specify --console-serial parameter on "kexec -l" commandline
> >   and it should display a message "I am in purgatory" on serial console.
> >   This will just mean that control has reached at least till purgatory.
> > 
> 
> Ok, so it reaches till here. I get "I'm in purgatory" on the console.

Hmm..., I just tried kexeing a 2.6.24-rc6-mm1 kernel from 2.6.24-rc6 on a
32bit box and it is working for me. That's a different thing 2.6.24-rc6-mm1
crashes later because of other problems.

Which kexec-tools are you using?  I am using kexec-tools-testing-20071030.


Thanks
Vivek

2.6.24-rc6-mm1 boot BUG()


Creating block device nodes.                                                    
Creating root device.                                                           
end_request: I/O error, dev fd0, sector 0                                       
input: ImPS/2 Generic Wheel Mouse as /class/input/input3                        
Mounting root filesystem.                                                       
end_request: I/O error, dev fd0, sector 0                                       
------------[ cut here ]------------                                            
kernel BUG at fs/buffer.c:1282!                                                 
invalid opcode: 0000 [#1] SMP                                                   
last sysfs file: /sys/block/hdc/dev                                             
Modules linked in:                                                              
                                                                                
Pid: 1, comm: init Not tainted (2.6.24-rc6-mm1 #2)                              
EIP: 0060:[<c017e98b>] EFLAGS: 00010046 CPU: 0                                  
EIP is at __find_get_block+0x1b/0x143                                           
EAX: 00000086 EBX: 00000000 ECX: 00000400 EDX: 00000001                         
ESI: 00000001 EDI: f78bc000 EBP: f746e380 ESP: f7823c60                         
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                                   
Process init (pid: 1, ti=f7822000 task=f7820000 task.ti=f7822000)               
Stack: 00000001 00000000 c014b17e 00000003 0000000a 0000c0d0 c16e2e00 c16e2ee0  
       f7177000 c16e2e00 c014bec4 00000000 00000001 f78bc000 f746e380 c017ecbd  
       00000400 00000001 00000000 00000000 00000000 0000c0d0 0000c0d0 c0560798  
Call Trace:                                                                     
 [<c014b17e>] __rmqueue+0x13/0x174                                              
 [<c014bec4>] get_page_from_freelist+0x2d1/0x344                                
 [<c017ecbd>] __getblk+0x21/0x295                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c018089b>] __bread+0xa/0x78                                                  
 [<c01c2353>] ext3_fill_super+0x138/0x1335                                      
 [<c0218d9e>] vsnprintf+0x407/0x445                                             
 [<c0218e52>] snprintf+0x1c/0x1f                                                
 [<c0194a0d>] disk_name+0x51/0x5b                                               
 [<c01665a1>] get_sb_bdev+0xce/0x10c                                            
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c0161c26>] __kmalloc+0x2f/0x9b                                               
 [<c01c0e06>] ext3_get_sb+0x12/0x16                                             
 [<c01c221b>] ext3_fill_super+0x0/0x1335                                        
 [<c01660ee>] vfs_kern_mount+0x39/0x72                                          
 [<c0166165>] do_kern_mount+0x2f/0xb4                                           
 [<c0176b00>] do_mount+0x5bf/0x621                                              
 [<c0175b12>] mntput_no_expire+0x11/0x85                                        
 [<c016c161>] link_path_walk+0x86/0x8f                                          
 [<c02d4e4a>] ide_disk_put+0x1c/0x27                                            
 [<c01672d9>] sys_stat64+0xf/0x23                                               
 [<c016534a>] put_filp+0x3c/0x9a                                                
 [<c014bc5c>] get_page_from_freelist+0x69/0x344                                 
 [<c0413309>] mutex_lock+0xb/0x1a                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c01757b2>] copy_mount_options+0x26/0x109                                     
 [<c0176bcf>] sys_mount+0x6d/0xaa                                               
 [<c01038e6>] syscall_call+0x7/0xb                                              
 =======================                                                        
Code: 24 04 e8 49 f9 fc ff 89 d8 5b 5e 5b 5e 5f 5d c3 55 89 c5 57 56 53 83 ec 2c
 89 4c 24 04 8b 4c 24 40 89 14 24 9c 58 f6 c4 02 75 04 <0f> 0b eb fe fa b8 00 bf
 5f c0 31 ff 64 8b 15 10 a1 5f c0 01 c2                                         
EIP: [<c017e98b>] __find_get_block+0x1b/0x143 SS:ESP 0068:f7823c60              
---[ end trace bca1d6c3657fce65 ]---                                            
Kernel panic - not syncing: Attempted to kill init!                             
WARNING: at arch/x86/kernel/smp_32.c:475 native_smp_send_reschedule()           
Pid: 1, comm: init Tainted: G      D 2.6.24-rc6-mm1 #2                          
 [<c0115784>] native_smp_send_reschedule+0x2e/0x4d                              
 [<c011cfae>] resched_task+0x56/0x58                                            
 [<c011e420>] resched_cpu+0x3c/0x49                                             
 [<c0120e22>] scheduler_tick+0x124/0x198                                        
 [<c012bff7>] update_process_times+0x3a/0x44                                    
 [<c013b380>] tick_sched_timer+0x73/0xb0                                        
 [<c0136c39>] hrtimer_interrupt+0x11f/0x1aa                                     
 [<c013b30d>] tick_sched_timer+0x0/0xb0                                         
 [<c01178d0>] smp_apic_timer_interrupt+0x69/0x78                                
 [<c010434c>] apic_timer_interrupt+0x28/0x30                                    
 [<c041007b>] rpc_pipe_read+0xeb/0x100                                          
 [<c01243a4>] panic+0xc6/0xe6                                                   
 [<c0126d8f>] do_exit+0x6b/0x5a7                                                
 [<c0104b74>] die+0x1c5/0x1ca                                                   
 [<c0104cfd>] do_invalid_op+0x0/0x6b                                            
 [<c0104d5f>] do_invalid_op+0x62/0x6b                                           
 [<c017e98b>] __find_get_block+0x1b/0x143                                       
 [<c041437a>] error_code+0x72/0x78                                              
 [<c014007b>] sys_init_module+0x379/0x1602                                      
 [<c017e98b>] __find_get_block+0x1b/0x143                                       
 [<c014b17e>] __rmqueue+0x13/0x174                                              
 [<c014bec4>] get_page_from_freelist+0x2d1/0x344                                
 [<c017ecbd>] __getblk+0x21/0x295                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c018089b>] __bread+0xa/0x78                                                  
 [<c01c2353>] ext3_fill_super+0x138/0x1335                                      
 [<c0218d9e>] vsnprintf+0x407/0x445                                             
 [<c0218e52>] snprintf+0x1c/0x1f                                                
 [<c0194a0d>] disk_name+0x51/0x5b                                               
 [<c01665a1>] get_sb_bdev+0xce/0x10c                                            
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c0161c26>] __kmalloc+0x2f/0x9b                                               
 [<c01c0e06>] ext3_get_sb+0x12/0x16                                             
 [<c01c221b>] ext3_fill_super+0x0/0x1335                                        
 [<c01660ee>] vfs_kern_mount+0x39/0x72                                          
 [<c0166165>] do_kern_mount+0x2f/0xb4                                           
 [<c0176b00>] do_mount+0x5bf/0x621                                              
 [<c0175b12>] mntput_no_expire+0x11/0x85                                        
 [<c016c161>] link_path_walk+0x86/0x8f                                          
 [<c02d4e4a>] ide_disk_put+0x1c/0x27                                            
 [<c01672d9>] sys_stat64+0xf/0x23                                               
 [<c016534a>] put_filp+0x3c/0x9a                                                
 [<c014bc5c>] get_page_from_freelist+0x69/0x344                                 
 [<c0413309>] mutex_lock+0xb/0x1a                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c01757b2>] copy_mount_options+0x26/0x109                                     
 [<c0176bcf>] sys_mount+0x6d/0xaa                                               
 [<c01038e6>] syscall_call+0x7/0xb                                              
 =======================                                                        
WARNING: at arch/x86/kernel/smp_32.c:209 send_IPI_mask_bitmask()                
Pid: 1, comm: init Tainted: G      D 2.6.24-rc6-mm1 #2                          
 [<c0115bbb>] send_IPI_mask_bitmask+0x33/0x80                                   
 [<c01157a1>] native_smp_send_reschedule+0x4b/0x4d                              
 [<c011cfae>] resched_task+0x56/0x58                                            
 [<c011e420>] resched_cpu+0x3c/0x49                                             
 [<c0120e22>] scheduler_tick+0x124/0x198                                        
 [<c012bff7>] update_process_times+0x3a/0x44                                    
 [<c013b380>] tick_sched_timer+0x73/0xb0                                        
 [<c0136c39>] hrtimer_interrupt+0x11f/0x1aa                                     
 [<c013b30d>] tick_sched_timer+0x0/0xb0                                         
 [<c01178d0>] smp_apic_timer_interrupt+0x69/0x78                                
 [<c010434c>] apic_timer_interrupt+0x28/0x30                                    
 [<c041007b>] rpc_pipe_read+0xeb/0x100                                          
 [<c01243a4>] panic+0xc6/0xe6                                                   
 [<c0126d8f>] do_exit+0x6b/0x5a7                                                
 [<c0104b74>] die+0x1c5/0x1ca                                                   
 [<c0104cfd>] do_invalid_op+0x0/0x6b                                            
 [<c0104d5f>] do_invalid_op+0x62/0x6b                                           
 [<c017e98b>] __find_get_block+0x1b/0x143                                       
 [<c041437a>] error_code+0x72/0x78                                              
 [<c014007b>] sys_init_module+0x379/0x1602                                      
 [<c017e98b>] __find_get_block+0x1b/0x143                                       
 [<c014b17e>] __rmqueue+0x13/0x174                                              
 [<c014bec4>] get_page_from_freelist+0x2d1/0x344                                
 [<c017ecbd>] __getblk+0x21/0x295                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c018089b>] __bread+0xa/0x78                                                  
 [<c01c2353>] ext3_fill_super+0x138/0x1335                                      
 [<c0218d9e>] vsnprintf+0x407/0x445                                             
 [<c0218e52>] snprintf+0x1c/0x1f                                                
 [<c0194a0d>] disk_name+0x51/0x5b                                               
 [<c01665a1>] get_sb_bdev+0xce/0x10c                                            
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c0161c26>] __kmalloc+0x2f/0x9b                                               
 [<c01c0e06>] ext3_get_sb+0x12/0x16                                             
 [<c01c221b>] ext3_fill_super+0x0/0x1335                                        
 [<c01660ee>] vfs_kern_mount+0x39/0x72                                          
 [<c0166165>] do_kern_mount+0x2f/0xb4                                           
 [<c0176b00>] do_mount+0x5bf/0x621                                              
 [<c0175b12>] mntput_no_expire+0x11/0x85                                        
 [<c016c161>] link_path_walk+0x86/0x8f                                          
 [<c02d4e4a>] ide_disk_put+0x1c/0x27                                            
 [<c01672d9>] sys_stat64+0xf/0x23                                               
 [<c016534a>] put_filp+0x3c/0x9a                                                
 [<c014bc5c>] get_page_from_freelist+0x69/0x344                                 
 [<c0413309>] mutex_lock+0xb/0x1a                                               
 [<c014bfb0>] __alloc_pages+0x67/0x2c5                                          
 [<c01757b2>] copy_mount_options+0x26/0x109                                     
 [<c0176bcf>] sys_mount+0x6d/0xaa                                               
 [<c01038e6>] syscall_call+0x7/0xb                                              
 =======================                                                        



