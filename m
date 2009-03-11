Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZCKRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZCKRJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZCKRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:09:09 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:25863 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZCKRJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:09:08 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Oopsen?
Date: Wed, 11 Mar 2009 13:08:58 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.28.7; KDE/4.2.0; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903111308.58917.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings everybody;

With less than 30 minutes uptime on a new bios version, running 2.6.28.7 on a 
quad core AMD 9550 machine, I get this in the logs (and a heck of a mess from 
sealert which has learned how to open a window that disables that screen, a 
PITA)

Mar 11 12:33:51 coyote kernel: [ 1394.369118] BUG: unable to handle kernel NULL pointer dereference at 00000006                          
Mar 11 12:33:51 coyote kernel: [ 1394.369123] IP: [<c0464f3d>] get_page_from_freelist+0x26d/0x4e0                                        
Mar 11 12:33:51 coyote kernel: [ 1394.369146] *pdpt = 000000002052a001 *pde = 0000000000000000                                           
Mar 11 12:33:51 coyote kernel: [ 1394.369153] Oops: 0000 [#1] PREEMPT SMP                                                                
Mar 11 12:33:51 coyote kernel: [ 1394.369159] last sysfs file: /sys/devices/pci0000:00/0000:00:0f.0/0000:03:00.1/local_cpus              
Mar 11 12:33:51 coyote kernel: [ 1394.369162] Modules linked in: fuse nls_utf8 cifs radeon drm eeprom nfsd rfcomm lockd nfs_acl 
auth_rpcgss exportfs sco bnep l2cap autofs4 sunrpc ipv6 snd_emu10k1_synth or51132 snd_emux_synth snd_seq_virmidi 
snd_seq_midi_emul cx88_dvb tuner_simple tuner_types snd_emu10k1 tda9887 tda8290 snd_rawmidi snd_ac97_codec ac97_bus tuner 
snd_seq_dummy snd_seq_oss cx8800 snd_seq_midi_event cx8802 snd_seq cx88xx snd_pcm_oss ir_common snd_mixer_oss i2c_algo_bit 
snd_pcm tveeprom videobuf_dvb videodev dvb_core snd_seq_device v4l1_compat snd_timer snd_page_alloc compat_ioctl32 snd_util_mem 
v4l2_common btcx_risc snd_hwdep snd videobuf_dma_sg floppy forcedeth firewire_ohci usb_storage videobuf_core ftdi_sio 
firewire_core sr_mod i2c_nforce2 cdrom usbserial sg usblp soundcore pcspkr i2c_core joydev btusb button crc_itu_t evdev 
bluetooth ahci pata_jmicron pata_amd ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd 
ehci_hcd [last unloaded: scsi_wait_scan]                                                                               
Mar 11 12:33:51 coyote kernel: [ 1394.369292]                                                                                            
Mar 11 12:33:51 coyote kernel: [ 1394.369295] Pid: 4410, comm: firefox-bin Not tainted (2.6.28.7 #6) System Product Name                 
Mar 11 12:33:51 coyote kernel: [ 1394.369298] EIP: 0060:[<c0464f3d>] EFLAGS: 00210246 CPU: 1                                             
Mar 11 12:33:51 coyote kernel: [ 1394.369302] EIP is at get_page_from_freelist+0x26d/0x4e0                                               
Mar 11 12:33:51 coyote kernel: [ 1394.369305] EAX: 00000000 EBX: 00000002 ECX: 80004000 EDX: 00000000                                    
Mar 11 12:33:51 coyote kernel: [ 1394.369308] ESI: c28fc260 EDI: 00000100 EBP: c06f3c80 ESP: c45aed28                                    
Mar 11 12:33:51 coyote kernel: [ 1394.369310]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                                              
Mar 11 12:33:51 coyote kernel: [ 1394.369314] Process firefox-bin (pid: 4410, ti=c45ae000 task=c6c967f0 task.ti=c45ae000)                
Mar 11 12:33:51 coyote kernel: [ 1394.369316] Stack:                                                                                     
Mar 11 12:33:51 coyote kernel: [ 1394.369318]  00000002 00000044 fffaa000 c0761fe0 00000002 00000000 00000000 001280d2                   
Mar 11 12:33:51 coyote kernel: [ 1394.369329]  00000002 00200246 00000001 c06f4100 00000000 00000000 c06f4c84 c06f3c80                   
Mar 11 12:33:51 coyote kernel: [ 1394.369341]  c06f3c80 c06f3c80 c6c967f0 f5d5fe40 001280d2 c046534d c06f4c80 00000003                   
Mar 11 12:33:51 coyote kernel: [ 1394.369354] Call Trace:                                                                                
Mar 11 12:33:51 coyote kernel: [ 1394.369357]  [<c046534d>] __alloc_pages_internal+0xbd/0x470                                            
Mar 11 12:33:51 coyote kernel: [ 1394.369362]  [<c0470be5>] handle_mm_fault+0x465/0x870                                                  
Mar 11 12:33:51 coyote kernel: [ 1394.369367]  [<c0417d46>] do_page_fault+0x156/0x830                                                    
Mar 11 12:33:51 coyote kernel: [ 1394.369372]  [<c049ffa6>] mnt_drop_write+0x56/0x130                                                    
Mar 11 12:33:51 coyote kernel: [ 1394.369377]  [<c0490d0b>] pipe_read+0x40b/0x410                                                        
Mar 11 12:33:51 coyote kernel: [ 1394.369382]  [<c041d516>] update_curr+0x136/0x1a0                                                      
Mar 11 12:33:51 coyote kernel: [ 1394.369386]  [<c043f7e7>] hrtimer_forward+0x147/0x1a0                                                  
Mar 11 12:33:51 coyote kernel: [ 1394.369391]  [<c04093c6>] read_tsc+0x6/0x40                                                            
Mar 11 12:33:51 coyote kernel: [ 1394.369396]  [<c0443aa1>] getnstimeofday+0x51/0x110                                                    
Mar 11 12:33:51 coyote kernel: [ 1394.369401]  [<c0412c80>] lapic_next_event+0x10/0x20                                                   
Mar 11 12:33:51 coyote kernel: [ 1394.369406]  [<c0446311>] clockevents_program_event+0xa1/0x160                                         
Mar 11 12:33:51 coyote kernel: [ 1394.369410]  [<c0447502>] tick_dev_program_event+0x32/0xb0                                             
Mar 11 12:33:51 coyote kernel: [ 1394.369414]  [<c04475fa>] tick_program_event+0x2a/0x40                                                 
Mar 11 12:33:51 coyote kernel: [ 1394.369419]  [<c0440905>] hrtimer_interrupt+0x1a5/0x1e0                                                
Mar 11 12:33:51 coyote kernel: [ 1394.369422]  [<c0458cb4>] audit_syscall_exit+0x394/0x3d0                                               
Mar 11 12:33:51 coyote kernel: [ 1394.369427]  [<c042ccb8>] sys_gettimeofday+0x28/0x80                                                   
Mar 11 12:33:51 coyote kernel: [ 1394.369432]  [<c0417bf0>] do_page_fault+0x0/0x830                                                      
Mar 11 12:33:51 coyote kernel: [ 1394.369436]  [<c062a412>] error_code+0x72/0x78                                                         
Mar 11 12:33:51 coyote kernel: [ 1394.369442] Code: f6 40 08 08 0f 85 74 02 00 00 8b 0e 89 f3 8b 46 08 8b 56 10 f6 c5 40 74 03 
8b 5e 0c 85 d2 0f 95 c2 83 c0 01 0f b6 d2 09 c2 31 c0 <83> 7b 04 00 0f 95 c0 09 c2 89 c8 25 f1 9c 3c 00 09 c2 0f 85 db                             
Mar 11 12:33:51 coyote kernel: [ 1394.369523] EIP: [<c0464f3d>] get_page_from_freelist+0x26d/0x4e0 SS:ESP 0068:c45aed28                  
Mar 11 12:33:51 coyote kernel: [ 1394.369531] ---[ end trace 5523db6be54b02cb ]--- 

is there something wrong in the kernels .config, or is this real?

Thank you.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Simon: "Ah, yes.  He's a real beast.  It's a wonder you're still alive."

Jayne: "...Looked bigger when I couldn't see him."
				--Episode #3, "Bushwacked"

