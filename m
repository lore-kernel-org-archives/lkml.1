Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0BMTSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:18:37 -0500
Received: from mail001.aei.ca ([206.123.6.130]:40665 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab0BMTSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:18:35 -0500
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: Re: [LOCKDEP] 33-rc8 Running aplay with pulse as the default
Date: Sat, 13 Feb 2010 14:18:26 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
Cc: alsa-devel@alsa-project.org
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain> <201002131217.10579.edt@aei.ca>
In-Reply-To: <201002131217.10579.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131418.26931.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 February 2010 12:17:10 Ed Tomlinson wrote:

Looks like can also trigger an opps that force me to reboot.  I tried
su - <id>
pulseaudio -D

and got the following lockdep traceback followed by an opps

This is grover.unknown_domain (Linux x86_64 2.6.33-rc8-crc) 13:53:37

grover login: [   87.254950] 
[   87.254952] =======================================================
[   87.255252] [ INFO: possible circular locking dependency detected ]
[   87.255252] 2.6.33-rc8-crc #106
[   87.255252] -------------------------------------------------------
[   87.255252] pulseaudio/2800 is trying to acquire lock:
[   87.255252]  (&dev->lock){+.+.+.}, at: [<ffffffffa027d7f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024] 
[   87.336024] but task is already holding lock:
[   87.336024]  (&pcm->open_mutex){+.+.+.}, at: [<ffffffffa00ffcd2>] snd_pcm_open+0x182/0x450 [snd_pcm]
[   87.336024] 
[   87.336024] which lock already depends on the new lock.
[   87.336024] 
[   87.336024] 
[   87.336024] the existing dependency chain (in reverse order) is:
[   87.336024] 
[   87.336024] -> #3 (&pcm->open_mutex){+.+.+.}:
[   87.336024]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550
[   87.336024]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140
[   87.336024]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610
[   87.336024]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
[   87.336024]        [<ffffffffa00fbd32>] snd_pcm_release+0x42/0xb0 [snd_pcm]
[   87.336024]        [<ffffffff8112115d>] __fput+0x15d/0x290
[   87.336024]        [<ffffffff811212ad>] fput+0x1d/0x30
[   87.336024]        [<ffffffff810fe001>] remove_vma+0x51/0x80
[   87.336024]        [<ffffffff810ffa1d>] do_munmap+0x2fd/0x390
[   87.336024]        [<ffffffff810ffb06>] sys_munmap+0x56/0x80
[   87.336024]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   87.336024] 
[   87.336024] -> #2 (&mm->mmap_sem){++++++}:
[   87.336024]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550
[   87.336024]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140
[   87.336024]        [<ffffffff810f62c7>] might_fault+0xa7/0xd0
[   87.336024]        [<ffffffff8113102b>] filldir+0x7b/0xe0
[   87.336024]        [<ffffffff8118aa21>] sysfs_readdir+0xf1/0x1b0
[   87.336024]        [<ffffffff81131268>] vfs_readdir+0xb8/0xe0
[   87.336024]        [<ffffffff8113144d>] sys_getdents+0xad/0x110
[   87.336024]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   87.336024] 
[   87.336024] -> #1 (sysfs_mutex){+.+.+.}:
[   87.336024]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550
[   87.336024]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140
[   87.336024]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610
[   87.336024]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
[   87.336024]        [<ffffffff8118b082>] sysfs_addrm_start+0x22/0x30
[   87.336024]        [<ffffffff8118bc58>] create_dir+0x58/0xb0
[   87.336024]        [<ffffffff8118bd0a>] sysfs_create_dir+0x5a/0x70
[   87.336024]        [<ffffffff8123ebbd>] kobject_add_internal+0xbd/0x1f0
[   87.336024]        [<ffffffff8123ee08>] kobject_add_varg+0x38/0x60
[   87.336024]        [<ffffffff8123eee4>] kobject_add+0x44/0x70
[   87.336024]        [<ffffffff81392510>] device_add+0xb0/0x5e0
[   87.336024]        [<ffffffff81392a5e>] device_register+0x1e/0x30
[   87.336024]        [<ffffffff8140a50d>] i2c_register_adapter+0x12d/0x250
[   87.336024]        [<ffffffff8140a7f1>] i2c_add_adapter+0xb1/0xd0
[   87.336024]        [<ffffffffa0207ba4>] em28xx_i2c_register+0x104/0x520 [em28xx]
[   87.336024]        [<ffffffffa0209daa>] em28xx_usb_probe+0x68a/0xb90 [em28xx]
[   87.336024]        [<ffffffff813eb4ab>] usb_probe_interface+0xeb/0x1b0
[   87.336024]        [<ffffffff81395546>] driver_probe_device+0xc6/0x1d0
[   87.336024]        [<ffffffff813956eb>] __driver_attach+0x9b/0xa0
[   87.336024]        [<ffffffff8139492c>] bus_for_each_dev+0x6c/0xa0
[   87.336024]        [<ffffffff8139535e>] driver_attach+0x1e/0x20
[   87.336024]        [<ffffffff81394c11>] bus_add_driver+0xe1/0x280
[   87.336024]        [<ffffffff81395a58>] driver_register+0x98/0x140
[   87.336024]        [<ffffffff813ea06c>] usb_register_driver+0xdc/0x1a0
[   87.336024]        [<ffffffffa021e023>] 0xffffffffa021e023
[   87.336024]        [<ffffffff810001dc>] do_one_initcall+0x3c/0x1d0
[   87.336024]        [<ffffffff81092d75>] sys_init_module+0xe5/0x250
[   87.336024]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   87.336024] 
[   87.336024] -> #0 (&dev->lock){+.+.+.}:
[   87.336024]        [<ffffffff81083668>] __lock_acquire+0x1418/0x1550
[   87.336024]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140
[   87.336024]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610
[   87.336024]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
[   87.336024]        [<ffffffffa027d7f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024]        [<ffffffffa00fbdee>] snd_pcm_open_substream+0x4e/0x90 [snd_pcm]
[   87.336024]        [<ffffffffa00ffce9>] snd_pcm_open+0x199/0x450 [snd_pcm]
[   87.336024]        [<ffffffffa00fffd4>] snd_pcm_capture_open+0x34/0x40 [snd_pcm]
[   87.336024]        [<ffffffffa00da778>] snd_open+0x198/0x4e0 [snd]
[   87.336024]        [<ffffffff8112384d>] chrdev_open+0x17d/0x320
[   87.336024]        [<ffffffff8111d358>] __dentry_open+0x1a8/0x400
[   87.336024]        [<ffffffff8111d6b4>] nameidata_to_filp+0x54/0x70
[   87.336024]        [<ffffffff8112e7f1>] do_filp_open+0x841/0xc00
[   87.336024]        [<ffffffff8111e954>] do_sys_open+0xa4/0x180
[   87.336024]        [<ffffffff8111ea70>] sys_open+0x20/0x30
[   87.336024]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   87.336024] 
[   87.336024] other info that might help us debug this:
[   87.336024] 
[   87.336024] 1 lock held by pulseaudio/2800:
[   87.336024]  #0:  (&pcm->open_mutex){+.+.+.}, at: [<ffffffffa00ffcd2>] snd_pcm_open+0x182/0x450 [snd_pcm]
[   87.336024] 
[   87.336024] stack backtrace:
[   87.336024] Pid: 2800, comm: pulseaudio Not tainted 2.6.33-rc8-crc #106
[   87.336024] Call Trace:
[   87.336024]  [<ffffffff81080fd9>] print_circular_bug+0xe9/0xf0
[   87.336024]  [<ffffffff81083668>] __lock_acquire+0x1418/0x1550
[   87.336024]  [<ffffffff81081dc8>] ? debug_check_no_locks_freed+0xc8/0x150
[   87.336024]  [<ffffffff8108383c>] lock_acquire+0x9c/0x140
[   87.336024]  [<ffffffffa027d7f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024]  [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610
[   87.336024]  [<ffffffffa027d7f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024]  [<ffffffffa027d7f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024]  [<ffffffffa00fac70>] ? snd_pcm_hw_rule_muldivk+0x0/0xa0 [snd_pcm]
[   87.336024]  [<ffffffff8107fd54>] ? lockdep_init_map+0x44/0x130
[   87.336024]  [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
[   87.336024]  [<ffffffffa027d7f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
[   87.336024]  [<ffffffffa00fbdee>] snd_pcm_open_substream+0x4e/0x90 [snd_pcm]
[   87.336024]  [<ffffffffa00ffce9>] snd_pcm_open+0x199/0x450 [snd_pcm]
[   87.336024]  [<ffffffff81081cfd>] ? trace_hardirqs_on+0xd/0x10
[   87.336024]  [<ffffffff810434f0>] ? default_wake_function+0x0/0x20
[   87.336024]  [<ffffffff814b965e>] ? mutex_unlock+0xe/0x10
[   87.336024]  [<ffffffffa00fffd4>] snd_pcm_capture_open+0x34/0x40 [snd_pcm]
[   87.336024]  [<ffffffffa00da778>] snd_open+0x198/0x4e0 [snd]
[   87.336024]  [<ffffffff8112384d>] chrdev_open+0x17d/0x320
[   87.336024]  [<ffffffff8111d358>] __dentry_open+0x1a8/0x400
[   87.336024]  [<ffffffff811236d0>] ? chrdev_open+0x0/0x320
[   87.336024]  [<ffffffff8111d6b4>] nameidata_to_filp+0x54/0x70
[   87.336024]  [<ffffffff8112e7f1>] do_filp_open+0x841/0xc00
[   87.336024]  [<ffffffff814bf981>] ? sub_preempt_count+0x51/0x60
[   87.336024]  [<ffffffff814bbb7c>] ? _raw_spin_unlock+0x5c/0x70
[   87.336024]  [<ffffffff8111e954>] do_sys_open+0xa4/0x180
[   87.336024]  [<ffffffff8111ea70>] sys_open+0x20/0x30
[   87.336024]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   89.153381] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   89.402672] BUG: unable to handle kernel NULL pointer dereference at (null)
[   89.403537] IP: [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   89.403537] PGD 16c019067 PUD 16c01a067 PMD 0 
[   89.403537] Oops: 0000 [#1] PREEMPT SMP 
[   89.403537] last sysfs file: /sys/devices/pci0000:00/0000:00:14.2/sound/card0/uevent
[   89.403537] CPU 1 
[   89.403537] Pid: 2813, comm: console-kit-dae Not tainted 2.6.33-rc8-crc #106 M3A78-T/System Product Name
[   89.403537] RIP: 0010:[<ffffffff8104dfe6>]  [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   89.403537] RSP: 0018:ffff88016dfcfe88  EFLAGS: 00010293
[   89.403537] RAX: ffff88016d29c318 RBX: fffffffffffffcf8 RCX: ffff88016b77d800
[   89.403537] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81a7f4c8
[   89.403537] RBP: ffff88016dfcfee8 R08: 0000000000000002 R09: 0000000000000000
[   89.403537] R10: 0000000000000000 R11: 0000000000000246 R12: ffff88016dfcff08
[   89.403537] R13: ffff88016d29c020 R14: ffff88016bd38000 R15: ffff88016bd38000
[   89.403537] FS:  00007f7fd4a7b700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
[   89.403537] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   89.403537] CR2: 0000000000000000 CR3: 000000016b12e000 CR4: 00000000000006e0
[   89.403537] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   89.600024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   89.600024] Process console-kit-dae (pid: 2813, threadinfo ffff88016dfce000, task ffff88016bd38000)
[   89.600024] Stack:
[   89.600024]  ffff88016bd38000 ffff88016bd38000 ffff88016dfcff30 ffff88016d29c318
[   89.600024] <0> ffff88016dfcfee8 0000000000000000 ffffffff81069880 00007fff88aaff4c
[   89.600024] <0> ffff88016b77d880 0000000000000000 000000000061ea60 00007fff88aaff9c
[   89.600024] Call Trace:
[   89.600024]  [<ffffffff81069880>] ? find_get_pid+0x0/0x80
[   89.600024]  [<ffffffff8104e169>] sys_wait4+0x89/0xf0
[   89.600024]  [<ffffffff8104b650>] ? child_wait_callback+0x0/0x80
[   89.600024]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[   89.600024] Code: eb 29 0f 1f 00 48 89 da be 01 00 00 00 4c 89 e7 e8 f0 f1 ff ff 85 c0 0f 85 d0 00 00 00 48 8b 9b 08 03 00 00 48 81 eb 08 03 00 00 <48> 8b 83 08 03 00 00 0f 18 08 48 8d 83 08 03 00 00 48 39 45 b8 
[   89.600024] RIP  [<ffffffff8104dfe6>] do_wait+0x1e6/0x2e0
[   89.600024]  RSP <ffff88016dfcfe88>
[   89.600024] CR2: 0000000000000000
[   89.600489] ---[ end trace 3efd4205cd3392b3 ]---
[   89.600492] note: console-kit-dae[2813] exited with preempt_count 1

> Hi,
> 
> Inorder to get skype working with linux I have the following in .asoundrc for my normal userid.
> 
> ---
> pcm.pulse {
>     type pulse
> }
> 
> ctl.pulse {
>     type pulse
> }
> 
> pcm.!default {
>     type pulse
> }
> ctl.!default {
>     type pulse
> ---
> 
> Try #1
> Starting as root if I do:
> su - <id>
> aplay sound.wav
> <traceback inlined below>
> aplay sound.wav 
> (silence)
> killall pulseaudio
> aplay sound.wav
> (works as expected now going thru pulseaudio)
> 
> Try #2
> Starting as root if I do:
> aplay sound.wav
> (works as expected using alsa alone)
> su - <id>
> aplay sound.wav
> <another lockdep traceback>
> aplay sound.wav
> (works as expected now going thru pulseaudio)
> 
> With .32 there were no tracebacks (lockdep was enabled) and try #1 would work where I now get silence.
> 
> Ideas?
> Ed Tomlinson
> 
> aplay -l
> **** List of PLAYBACK Hardware Devices ****
> card 0: SB [HDA ATI SB], device 0: ALC1200 Analog [ALC1200 Analog]
>   Subdevices: 0/1
>   Subdevice #0: subdevice #0
> card 0: SB [HDA ATI SB], device 1: ALC1200 Digital [ALC1200 Digital]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 1: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> 
> "ALC1200 Analog" is what has speakers connected
> 
> The em28xx in the traceback is an input source from a usb hdtv dongle.
> 
> pavucontrol setup has been verified.
> 
> [   91.070620]                                                                                                                               
> [   91.070621] =======================================================                                                                       
> [   91.071378] [ INFO: possible circular locking dependency detected ]                                                                       
> [   91.071378] 2.6.33-rc8-crc #106                                                                                                           
> [   91.071378] -------------------------------------------------------                                                                       
> [   91.071378] pulseaudio/2717 is trying to acquire lock:                                                                                    
> [   91.071378]  (&dev->lock){+.+.+.}, at: [<ffffffffa02797f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]                              
> [   91.071378]                                                                                                                               
> [   91.071378] but task is already holding lock:                                                                                             
> [   91.071378]  (&pcm->open_mutex){+.+.+.}, at: [<ffffffffa010ecd2>] snd_pcm_open+0x182/0x450 [snd_pcm]                                      
> [   91.071378]                                                                                                                               
> [   91.071378] which lock already depends on the new lock.                                                                                   
> [   91.071378]                                                                                                                               
> [   91.071378]                                                                                                                               
> [   91.071378] the existing dependency chain (in reverse order) is:                                                                          
> [   91.071378]                                                                                                                               
> [   91.071378] -> #3 (&pcm->open_mutex){+.+.+.}:                                                                                             
> [   91.071378]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550                                                                       
> [   91.071378]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140                                                                           
> [   91.071378]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610                                                                    
> [   91.071378]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50                                                                       
> [   91.071378]        [<ffffffffa010ad32>] snd_pcm_release+0x42/0xb0 [snd_pcm]                                                               
> [   91.071378]        [<ffffffff8112115d>] __fput+0x15d/0x290                                                                                
> [   91.071378]        [<ffffffff811212ad>] fput+0x1d/0x30                                                                                    
> [   91.071378]        [<ffffffff810fe001>] remove_vma+0x51/0x80                                                                              
> [   91.071378]        [<ffffffff810ffa1d>] do_munmap+0x2fd/0x390                                                                             
> [   91.071378]        [<ffffffff810ffb06>] sys_munmap+0x56/0x80                                                                              
> [   91.071378]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b                                                                    
> [   91.071378]                                                                                                                               
> [   91.071378] -> #2 (&mm->mmap_sem){++++++}:                                                                                                
> [   91.071378]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550                                                                       
> [   91.071378]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140                                                                           
> [   91.071378]        [<ffffffff810f62c7>] might_fault+0xa7/0xd0                                                                             
> [   91.071378]        [<ffffffff8113102b>] filldir+0x7b/0xe0                                                                                 
> [   91.071378]        [<ffffffff8118aa21>] sysfs_readdir+0xf1/0x1b0                                                                          
> [   91.071378]        [<ffffffff81131268>] vfs_readdir+0xb8/0xe0                                                                             
> [   91.071378]        [<ffffffff8113144d>] sys_getdents+0xad/0x110                                                                           
> [   91.071378]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b                                                                    
> [   91.071378]                                                                                                                               
> [   91.071378] -> #1 (sysfs_mutex){+.+.+.}:                                                                                                  
> [   91.071378]        [<ffffffff81083215>] __lock_acquire+0xfc5/0x1550                                                                       
> [   91.071378]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140                                                                           
> [   91.071378]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610                                                                    
> [   91.071378]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50                                                                       
> [   91.071378]        [<ffffffff8118b082>] sysfs_addrm_start+0x22/0x30                                                                       
> [   91.071378]        [<ffffffff8118bc58>] create_dir+0x58/0xb0                                                                              
> [   91.514885]        [<ffffffff8118bd0a>] sysfs_create_dir+0x5a/0x70                                                                        
> [   91.514885]        [<ffffffff8123ebbd>] kobject_add_internal+0xbd/0x1f0                                                                   
> [   91.514885]        [<ffffffff8123ee08>] kobject_add_varg+0x38/0x60                                                                        
> [   91.514885]        [<ffffffff8123eee4>] kobject_add+0x44/0x70                                                                             
> [   91.514885]        [<ffffffff81392510>] device_add+0xb0/0x5e0                                                                             
> [   91.514885]        [<ffffffff81392a5e>] device_register+0x1e/0x30                                                                         
> [   91.514885]        [<ffffffff8140a50d>] i2c_register_adapter+0x12d/0x250                                                                  
> [   91.514885]        [<ffffffff8140a7f1>] i2c_add_adapter+0xb1/0xd0                                                                         
> [   91.514885]        [<ffffffffa0231ba4>] em28xx_i2c_register+0x104/0x520 [em28xx]                                                          
> [   91.514885]        [<ffffffffa0233daa>] em28xx_usb_probe+0x68a/0xb90 [em28xx]                                                             
> [   91.514885]        [<ffffffff813eb4ab>] usb_probe_interface+0xeb/0x1b0                                                                    
> [   91.514885]        [<ffffffff81395546>] driver_probe_device+0xc6/0x1d0                                                                    
> [   91.514885]        [<ffffffff813956eb>] __driver_attach+0x9b/0xa0                                                                         
> [   91.514885]        [<ffffffff8139492c>] bus_for_each_dev+0x6c/0xa0                                                                        
> [   91.514885]        [<ffffffff8139535e>] driver_attach+0x1e/0x20                                                                           
> [   91.514885]        [<ffffffff81394c11>] bus_add_driver+0xe1/0x280                                                                         
> [   91.514885]        [<ffffffff81395a58>] driver_register+0x98/0x140                                                                        
> [   91.514885]        [<ffffffff813ea06c>] usb_register_driver+0xdc/0x1a0                                                                    
> [   91.514885]        [<ffffffffa0248023>] 0xffffffffa0248023                                                                                
> [   91.514885]        [<ffffffff810001dc>] do_one_initcall+0x3c/0x1d0                                                                        
> [   91.514885]        [<ffffffff81092d75>] sys_init_module+0xe5/0x250                                                                        
> [   91.514885]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b                                                                    
> [   91.514885]                                                                                                                               
> [   91.514885] -> #0 (&dev->lock){+.+.+.}:                                                                                                   
> [   91.514885]        [<ffffffff81083668>] __lock_acquire+0x1418/0x1550                                                                      
> [   91.514885]        [<ffffffff8108383c>] lock_acquire+0x9c/0x140                                                                           
> [   91.514885]        [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610                                                                    
> [   91.514885]        [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
> [   91.514885]        [<ffffffffa02797f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
> [   91.514885]        [<ffffffffa010adee>] snd_pcm_open_substream+0x4e/0x90 [snd_pcm]
> [   91.514885]        [<ffffffffa010ece9>] snd_pcm_open+0x199/0x450 [snd_pcm]
> [   91.514885]        [<ffffffffa010efd4>] snd_pcm_capture_open+0x34/0x40 [snd_pcm]
> [   91.514885]        [<ffffffffa00c5778>] snd_open+0x198/0x4e0 [snd]
> [   91.514885]        [<ffffffff8112384d>] chrdev_open+0x17d/0x320
> [   91.514885]        [<ffffffff8111d358>] __dentry_open+0x1a8/0x400
> [   91.514885]        [<ffffffff8111d6b4>] nameidata_to_filp+0x54/0x70
> [   91.514885]        [<ffffffff8112e7f1>] do_filp_open+0x841/0xc00
> [   91.514885]        [<ffffffff8111e954>] do_sys_open+0xa4/0x180
> [   91.514885]        [<ffffffff8111ea70>] sys_open+0x20/0x30
> [   91.514885]        [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
> [   91.514885]
> [   91.514885] other info that might help us debug this:
> [   91.514885]
> [   91.514885] 1 lock held by pulseaudio/2717:
> [   91.514885]  #0:  (&pcm->open_mutex){+.+.+.}, at: [<ffffffffa010ecd2>] snd_pcm_open+0x182/0x450 [snd_pcm]
> [   91.514885]
> [   91.514885] stack backtrace:
> [   91.514885] Pid: 2717, comm: pulseaudio Not tainted 2.6.33-rc8-crc #106
> [   91.514885] Call Trace:
> [   91.514885]  [<ffffffff81080fd9>] print_circular_bug+0xe9/0xf0
> [   91.514885]  [<ffffffff81083668>] __lock_acquire+0x1418/0x1550
> [   91.514885]  [<ffffffff81081dc8>] ? debug_check_no_locks_freed+0xc8/0x150
> [   91.514885]  [<ffffffff8108383c>] lock_acquire+0x9c/0x140
> [   91.514885]  [<ffffffffa02797f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
> [   91.514885]  [<ffffffff814b96c1>] __mutex_lock_common+0x61/0x610
> [   91.514885]  [<ffffffffa02797f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
> [   91.514885]  [<ffffffffa02797f1>] ? snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
> [   91.514885]  [<ffffffffa0109c70>] ? snd_pcm_hw_rule_muldivk+0x0/0xa0 [snd_pcm]
> [   91.514885]  [<ffffffff8107fd54>] ? lockdep_init_map+0x44/0x130
> [   91.514885]  [<ffffffff814b9d53>] mutex_lock_nested+0x43/0x50
> [   91.514885]  [<ffffffffa02797f1>] snd_em28xx_capture_open+0x61/0x190 [em28xx_alsa]
> [   91.514885]  [<ffffffffa010adee>] snd_pcm_open_substream+0x4e/0x90 [snd_pcm]
> [   91.514885]  [<ffffffffa010ece9>] snd_pcm_open+0x199/0x450 [snd_pcm]
> [   91.514885]  [<ffffffff81081cfd>] ? trace_hardirqs_on+0xd/0x10
> [   91.514885]  [<ffffffff810434f0>] ? default_wake_function+0x0/0x20
> [   91.514885]  [<ffffffff814b965e>] ? mutex_unlock+0xe/0x10
> [   91.514885]  [<ffffffffa010efd4>] snd_pcm_capture_open+0x34/0x40 [snd_pcm]
> [   91.514885]  [<ffffffffa00c5778>] snd_open+0x198/0x4e0 [snd]
> [   91.514885]  [<ffffffff8112384d>] chrdev_open+0x17d/0x320
> [   91.514885]  [<ffffffff8111d358>] __dentry_open+0x1a8/0x400
> [   91.514885]  [<ffffffff811236d0>] ? chrdev_open+0x0/0x320
> [   91.514885]  [<ffffffff8111d6b4>] nameidata_to_filp+0x54/0x70
> [   91.514885]  [<ffffffff8112e7f1>] do_filp_open+0x841/0xc00
> [   91.514885]  [<ffffffff814bf981>] ? sub_preempt_count+0x51/0x60
> [   91.514885]  [<ffffffff814bbb7c>] ? _raw_spin_unlock+0x5c/0x70
> [   91.514885]  [<ffffffff8111e954>] do_sys_open+0xa4/0x180
> [   91.514885]  [<ffffffff8111ea70>] sys_open+0x20/0x30
> [   91.514885]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
> [   92.643423] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
