Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZIIQaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZIIQaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZIIQaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:30:14 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34561 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZIIQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:30:13 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=F03kvJlwzY8A:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=2oQlO_082Wk0blKPXAAA:9 a=lhNZuE14fjbF7OcDoK8A:7
 a=pG-aTRadn2wRX1Dwi1GArJtlHwQA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc9 kernel BUG (was: Re: 2.6.31-rc8 libata WARNING?)
Date: Wed, 9 Sep 2009 10:30:13 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9; KDE/4.3.1; x86_64; ; )
References: <200909090414.41274.tfjellstrom@shaw.ca>
In-Reply-To: <200909090414.41274.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Message-Id: <200909091030.13147.tfjellstrom@shaw.ca>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed September 9 2009, Thomas Fjellstrom wrote:
> Ok, After doing some more tests, I can be fairly certain that my disk is
>  not at fault, testing just ONE of my 2 WD Green drives, not using any md
>  raid, or filesystem on top I get the following:
> 
> [  329.394283] ------------[ cut here ]------------
> [  329.394361] WARNING: at drivers/ata/libata-core.c:5129
> ata_qc_issue+0x10a/0x347 [libata]()
> [  329.394367] Hardware name: GA-MA790FXT-UD5P
> [  329.394371] Modules linked in: powernow_k8 cpufreq_conservative
> cpufreq_stats cpufreq_userspace cpufreq_powersave kvm_amd kvm nfsd exportfs
> nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid
>  adt7473 firewire_sbp2 loop md_mod snd_hda_codec_realtek snd_hda_intel
>  snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm amd64_edac_mod
>  snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
>  snd_seq_device edac_core snd i2c_piix4 soundcore i2c_core snd_page_alloc
>  evdev parport_pc parport button wmi processor ext3 jbd mbcache dm_mod sg
>  usbhid sr_mod hid cdrom pata_jmicron firewire_ohci firewire_core
>  ata_generic sd_mod crc_t10dif ohci_hcd crc_itu_t atiixp ide_pci_generic
>  ide_core ahci mvsas ehci_hcd libsas libata
> scsi_transport_sas scsi_mod r8169 mii floppy thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> [  329.394488] Pid: 3103, comm: hddtemp Not tainted 2.6.31-rc8 #1
> [  329.394493] Call Trace:
> [  329.394540]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347 [libata]
> [  329.394583]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347 [libata]
> [  329.394596]  [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3
> [  329.394639]  [<ffffffffa00810ce>] ? ata_scsi_pass_thru+0x0/0x240
>  [libata] [  329.394680]  [<ffffffffa007cf90>] ? ata_qc_issue+0x10a/0x347
>  [libata] [  329.394726]  [<ffffffffa00401d6>] ? scsi_get_command+0x75/0x97
>  [scsi_mod] [  329.394768]  [<ffffffffa00810ce>] ?
>  ata_scsi_pass_thru+0x0/0x240 [libata] [  329.394807]  [<ffffffffa003f7aa>]
>  ? scsi_done+0x0/0xc [scsi_mod] [  329.394850]  [<ffffffffa00824d5>] ?
>  __ata_scsi_queuecmd+0x185/0x1dc [libata]
> [  329.394889]  [<ffffffffa003f7aa>] ? scsi_done+0x0/0xc [scsi_mod]
> [  329.394911]  [<ffffffffa00abc8e>] ? sas_queuecommand+0x83/0x25d [libsas]
> [  329.394949]  [<ffffffffa003fa7c>] ? scsi_dispatch_cmd+0x1c0/0x23c
> [scsi_mod]
> [  329.394988]  [<ffffffffa0044ff0>] ? scsi_request_fn+0x3a5/0x506
>  [scsi_mod] [  329.394999]  [<ffffffff810546e0>] ? del_timer+0x59/0x62
> [  329.395009]  [<ffffffff81163b08>] ? blk_execute_rq_nowait+0x65/0x89
> [  329.395024]  [<ffffffffa016764f>] ? sg_common_write+0x489/0x4ab [sg]
> [  329.395034]  [<ffffffff8115deee>] ? __freed_request+0x26/0x83
> [  329.395048]  [<ffffffffa01681da>] ? sg_new_write+0x23e/0x269 [sg]
> [  329.395062]  [<ffffffffa0168473>] ? sg_ioctl+0x26e/0xb63 [sg]
> [  329.395072]  [<ffffffff81100ef8>] ? inotify_d_instantiate+0x12/0x39
> [  329.395081]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
> [  329.395090]  [<ffffffff810d8097>] ? fd_install+0x2e/0x5a
> [  329.395097]  [<ffffffff810e5207>] ? vfs_ioctl+0x56/0x6c
> [  329.395104]  [<ffffffff810e56ca>] ? do_vfs_ioctl+0x437/0x475
> [  329.395111]  [<ffffffff810e5759>] ? sys_ioctl+0x51/0x70
> [  329.395121]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
> [  329.395127] ---[ end trace 2e6f5d9886b0398e ]---
> 
> 
> And that happens after only a couple minutes of: dd if=/dev/sdc
>  of=/dev/null
> 
> And this is with the WD that wasn't previously showing up in any dmesg
>  logs. I'm assuming if I let the dd test run, I will continue to see more
>  errors until the entire libata subsystem causes the sata driver to kneel
>  over and die.
> 
> I'm going to let it run for a while to see what happens.
> 

No errors on that disk. Other than the one above, and its more of a warning. 
However, I just rebooted to add some extra drives, thinking everything was 
working a little better now that I've updated to 2.6.31-rc9, I'm treated to 
the following two messages right after boot (and a system lockup to boot):

kernel: [  971.033138] ------------[ cut here ]------------                                                                                                                                                                                 
kernel: [  971.033211] WARNING: at drivers/ata/libata-core.c:4913 
__ata_qc_complete+0x5a/0xe1 [libata]()                                                                                                                                    
kernel: [  971.033217] Hardware name: GA-MA790FXT-UD5P                                                                                                                                                                                      
kernel: [  971.033221] Modules linked in: powernow_k8 cpufreq_conservative 
cpufreq_stats cpufreq_userspace cpufreq_powersave kvm_amd kvm nfsd exportfs 
nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473 
firewire_sbp2 loop md_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd amd64_edac_mod 
edac_core i2c_piix4 soundcore snd_page_alloc i2c_core evdev wmi parport_pc 
button parport processor ext3 jbd mbcache dm_mod sg sr_mod cdrom sd_mod 
crc_t10dif usbhid ata_generic ide_pci_generic hid mvsas firewire_ohci libsas 
firewire_core crc_itu_t scsi_transport_sas r8169 atiixp ide_core floppy ahci 
mii ohci_hcd libata ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded: 
scsi_wait_scan]                                                                                                        
kernel: [  971.033337] Pid: 0, comm: swapper Not tainted 2.6.31-rc9 #2                                                                                                                                                                      
kernel: [  971.033342] Call Trace:                                                                                                                                                                                                          
kernel: [  971.033346]  <IRQ>  [<ffffffffa00562ca>] ? 
__ata_qc_complete+0x5a/0xe1 [libata]                                                                                                                                                  
kernel: [  971.033434]  [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1 
[libata]                                                                                                                                                         
kernel: [  971.033446]  [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3                                                                                                                                                               
kernel: [  971.033455]  [<ffffffff81038d06>] ? enqueue_task+0x5c/0x65                                                                                                                                                                       
kernel: [  971.033496]  [<ffffffffa00562ca>] ? __ata_qc_complete+0x5a/0xe1 
[libata]                                                                                                                                                         
kernel: [  971.033519]  [<ffffffffa00f7b59>] ? sas_ata_task_done+0x178/0x210 
[libsas]                                                                                                                                                       
kernel: [  971.033528]  [<ffffffff8115ead1>] ? blk_run_queue+0x21/0x35                                                                                                                                                                      
kernel: [  971.033548]  [<ffffffffa010e2ce>] ? mvs_slot_complete+0x3df/0x41b 
[mvsas]                                                                                                                                                        
kernel: [  971.033565]  [<ffffffffa010e39c>] ? mvs_int_rx+0x92/0x101 [mvsas]                                                                                                                                                                
kernel: [  971.033583]  [<ffffffffa01112ba>] ? mvs_int_full+0x25/0x88 [mvsas]                                                                                                                                                               
kernel: [  971.033600]  [<ffffffffa011134e>] ? mvs_64xx_isr+0x31/0x40 [mvsas]                                                                                                                                                               
kernel: [  971.033617]  [<ffffffffa010d0e5>] ? mvs_interrupt+0x61/0x78 [mvsas]                                                                                                                                                              
kernel: [  971.033625]  [<ffffffff8108aaac>] ? handle_IRQ_event+0x58/0x135                                                                                                                                                                  
kernel: [  971.033633]  [<ffffffff8108c1a1>] ? handle_fasteoi_irq+0x7d/0xb5                                                                                                                                                                 
kernel: [  971.033642]  [<ffffffff8101388d>] ? handle_irq+0x17/0x1d                                                                                                                                                                         
kernel: [  971.033649]  [<ffffffff81012ee5>] ? do_IRQ+0x57/0xb6                                                                                                                                                                             
kernel: [  971.033656]  [<ffffffff81011413>] ? ret_from_intr+0x0/0x11                                                                                                                                                                       
kernel: [  971.033660]  <EOI>  [<ffffffff8102b520>] ? native_safe_halt+0x2/0x3                                                                                                                                                              
kernel: [  971.033676]  [<ffffffff81017c61>] ? default_idle+0x40/0x68                                                                                                                                                                       
kernel: [  971.033684]  [<ffffffff810684d0>] ? clockevents_notify+0x2b/0x7c                                                                                                                                                                 
kernel: [  971.033692]  [<ffffffff8101805e>] ? c1e_idle+0xd3/0xfb                                                                                                                                                                           
kernel: [  971.033700]  [<ffffffff8100fd9b>] ? cpu_idle+0x50/0x91                                                                                                                                                                           
kernel: [  971.033706] ---[ end trace bb4a1fceddfa8284 ]---                                                                                                                                                                                 
kernel: [  998.728950] ------------[ cut here ]------------                                                                                                                                                                                 
kernel: [  998.728961] kernel BUG at mm/slab.c:2974!                                                                                                                                                                                        
kernel: [  998.728967] invalid opcode: 0000 [#1] SMP                                                                                                                                                                                        
kernel: [  998.728974] last sysfs file: 
/sys/devices/platform/it87.552/temp1_input                                                                                                                                                          
kernel: [  998.728979] CPU 2                                                                                                                                                                                                                
kernel: [  998.728983] Modules linked in: powernow_k8 cpufreq_conservative 
cpufreq_stats cpufreq_userspace cpufreq_powersave kvm_amd kvm nfsd exportfs 
nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp it87 hwmon_vid adt7473 
firewire_sbp2 loop md_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd amd64_edac_mod 
edac_core i2c_piix4 soundcore snd_page_alloc i2c_core evdev wmi parport_pc 
button parport processor ext3 jbd mbcache dm_mod sg sr_mod cdrom sd_mod 
crc_t10dif usbhid ata_generic ide_pci_generic hid mvsas firewire_ohci libsas 
firewire_core crc_itu_t scsi_transport_sas r8169 atiixp ide_core floppy ahci 
mii ohci_hcd libata ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded: 
scsi_wait_scan]                                                                                                        
kernel: [  998.729105] Pid: 8278, comm: hddtemp Tainted: G        W  2.6.31-
rc9 #2 GA-MA790FXT-UD5P                                                                                                                                         
kernel: [  998.729111] RIP: 0010:[<ffffffff810d4c17>]  [<ffffffff810d4c17>] 
cache_alloc_refill+0xf6/0x1f9                                                                                                                                   
kernel: [  998.729128] RSP: 0018:ffff88012e1dfab8  EFLAGS: 00010086                                                                                                                                                                         
kernel: [  998.729134] RAX: 00000000fffffffe RBX: ffff88012b90cc40 RCX: 
0000000000000000                                                                                                                                                    
kernel: [  998.729140] RDX: 0000000000000000 RSI: ffff880109597140 RDI: 
ffff88012b90cc50                                                                                                                                                    
kernel: [  998.729145] RBP: ffff88012b911a00 R08: ffff88012b90cc60 R09: 
0000000000000086                                                                                                                                                    
kernel: [  998.729151] R10: 00007fff9c05cc30 R11: 0000000100000002 R12: 
0000000000000010                                                                                                                                                    
kernel: [  998.729156] R13: ffff88012b9366c0 R14: 0000000000049220 R15: 
0000000000000000                                                                                                                                                    
kernel: [  998.729163] FS:  00007f07cfd826f0(0000) GS:ffff88002805c000(0000) 
knlGS:00000000f76fbbb0                                                                                                                                         
kernel: [  998.729169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                                                                    
kernel: [  998.729174] CR2: 00000000084ec298 CR3: 000000012e1d9000 CR4: 
00000000000006e0                                                                                                                                                    
kernel: [  998.729179] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000                                                                                                                                                    
kernel: [  998.729185] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400                                                                                                                                                    
kernel: [  998.729191] Process hddtemp (pid: 8278, threadinfo 
ffff88012e1de000, task ffff88012d8dd100)                                                                                                                                      
kernel: [  998.729196] Stack:                                                                                                                                                                                                               
kernel: [  998.729199]  ffff880105c64918 ffff88012b9366c0 ffff88012ac97a00 
0000000000008020                                                                                                                                                 
kernel: [  998.729207] <0> 0000000000000002 0000000000008020 ffff88012bc8e000 
ffffffff810d4fb7                                                                                                                                              
kernel: [  998.729216] <0> 0000000000000000 ffff88012ac97a00 ffff88012aed40d0 
ffffffffa005c0ce                                                                                                                                              
kernel: [  998.729225] Call Trace:                                                                                                                                                                                                          
kernel: [  998.729236]  [<ffffffff810d4fb7>] ? kmem_cache_alloc+0xe9/0x175                                                                                                                                                                  
kernel: [  998.729287]  [<ffffffffa005c0ce>] ? ata_scsi_pass_thru+0x0/0x240 
[libata]                                                                                                                                                        
kernel: [  998.729311]  [<ffffffffa00f7055>] ? sas_alloc_task+0x14/0x62 
[libsas]                                                                                                                                                            
kernel: [  998.729331]  [<ffffffffa00f77ff>] ? sas_ata_qc_issue+0x3b/0x21d 
[libsas]                                                                                                                                                         
kernel: [  998.729373]  [<ffffffffa005c0ce>] ? ata_scsi_pass_thru+0x0/0x240 
[libata]                                                                                                                                                        
kernel: [  998.729415]  [<ffffffffa0058184>] ? ata_qc_issue+0x2fe/0x347 
[libata]                                                                                                                                                            
kernel: [  998.729456]  [<ffffffffa001b1d6>] ? scsi_get_command+0x75/0x97 
[scsi_mod]                                                                                                                                                        
kernel: [  998.729498]  [<ffffffffa005c0ce>] ? ata_scsi_pass_thru+0x0/0x240 
[libata]                                                                                                                                                        
kernel: [  998.729536]  [<ffffffffa001a7aa>] ? scsi_done+0x0/0xc [scsi_mod]                                                                                                                                                                 
kernel: [  998.729578]  [<ffffffffa005d4d5>] ? __ata_scsi_queuecmd+0x185/0x1dc 
[libata]                                                                                                                                                     
kernel: [  998.729615]  [<ffffffffa001a7aa>] ? scsi_done+0x0/0xc [scsi_mod]                                                                                                                                                                 
kernel: [  998.729635]  [<ffffffffa00f6c8e>] ? sas_queuecommand+0x83/0x25d 
[libsas]                                                                                                                                                         
kernel: [  998.729673]  [<ffffffffa001aa7c>] ? scsi_dispatch_cmd+0x1c0/0x23c 
[scsi_mod]                                                                                                                                                     
kernel: [  998.729712]  [<ffffffffa001fff0>] ? scsi_request_fn+0x3a5/0x506 
[scsi_mod]                                                                                                                                                       
kernel: [  998.729723]  [<ffffffff810546e0>] ? del_timer+0x59/0x62                                                                                                                                                                          
kernel: [  998.729733]  [<ffffffff81163b70>] ? blk_execute_rq_nowait+0x65/0x89                                                                                                                                                              
kernel: [  998.729749]  [<ffffffffa016964f>] ? sg_common_write+0x489/0x4ab 
[sg]                                                                                                                                                             
kernel: [  998.729759]  [<ffffffff8115df56>] ? __freed_request+0x26/0x83                                                                                                                                                                    
kernel: [  998.729773]  [<ffffffffa016a1da>] ? sg_new_write+0x23e/0x269 [sg]                                                                                                                                                                
kernel: [  998.729786]  [<ffffffffa016a473>] ? sg_ioctl+0x26e/0xb63 [sg]                                                                                                                                                                    
kernel: [  998.729796]  [<ffffffff81100f38>] ? inotify_d_instantiate+0x12/0x39                                                                                                                                                              
kernel: [  998.729805]  [<ffffffff8105eee6>] ? 
autoremove_wake_function+0x0/0x2e                                                                                                                                                            
kernel: [  998.729813]  [<ffffffff810d80bf>] ? fd_install+0x2e/0x5a                                                                                                                                                                         
kernel: [  998.729820]  [<ffffffff810e5247>] ? vfs_ioctl+0x56/0x6c                                                                                                                                                                          
kernel: [  998.729827]  [<ffffffff810e570a>] ? do_vfs_ioctl+0x437/0x475                                                                                                                                                                     
kernel: [  998.729834]  [<ffffffff810e5799>] ? sys_ioctl+0x51/0x70                                                                                                                                                                          
kernel: [  998.729844]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b                                                                                                                                                               
kernel: [  998.729848] Code: 00 00 00 48 8b 33 48 39 de 75 14 48 8b 73 20 c7 
43 60 01 00 00 00 4c 39 c6 0f 84 a4 00 00 00 8b 46 20 41 3b 85 18 10 00 00 72 
31 <0f> 0b eb fe ff c0 8b 4d 00 41 8b 95 0c 10 00 00 89 46 20 8b 46              
kernel: [  998.729913] RIP  [<ffffffff810d4c17>] cache_alloc_refill+0xf6/0x1f9                                                                                                                                                              
kernel: [  998.729922]  RSP <ffff88012e1dfab8>                                                                                                                                                                                              
kernel: [  998.729928] ---[ end trace bb4a1fceddfa8285 ]---

The added hard drives are connected to a Supermicro AOC-SASLP-MV8, which is 
based on a marvel MV64460/64461/64462 chipset, which uses the sata_mv driver.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
