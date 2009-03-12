Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZCLSco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZCLSco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZCLScJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:32:09 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:39735 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbZCLScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:32:06 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: David Newall <davidn@davidnewall.com>
Subject: Re: I just got got another Oops
Date: Thu, 12 Mar 2009 14:31:49 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7; KDE/4.2.0; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903120133.11583.gene.heskett@gmail.com>
 <49B8C98D.3020309@davidnewall.com>
In-reply-to: <49B8C98D.3020309@davidnewall.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903121431.49437.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, David Newall wrote:
>Gene Heskett wrote:
>> Mar 12 01:15:01 coyote xinetd[2583]: START: amanda pid=8970
>> from=::ffff:192.168.71.3 Mar 12 01:16:21 coyote kernel: [10353.910914]
>> BUG: unable to handle kernel NULL pointer dereference at 00000006 Mar 12
>> 01:16:21 coyote kernel: [10353.910921] IP: [<c046520b>]
>> get_page_from_freelist+0x24b/0x4c0 Mar 12 01:16:21 coyote kernel:
>> [10353.910929] *pdpt = 0000000000b38001 *pde = 0000000000000000 Mar 12
>> 01:16:21 coyote kernel: [10353.910934] Oops: 0000 [#1] PREEMPT SMP
>
>I think there must be a zone at 0x0.  Try adding
>
>		if (!zone) goto try_next_zone;
>
>
>in mm/page_alloc.c, (near line 1469), before
>
>		if (NUMA_BUILD && zlc_active &&
I don't believe that was the fix, David.  I just got another Oops
And this time word wrap is turned off before I paste from the log:

I thought it was the last time, sigh...

==============================
Mar 12 14:15:02 coyote kernel: [ 2656.832576] BUG: unable to handle kernel NULL pointer dereference at 00000006                          
Mar 12 14:15:02 coyote kernel: [ 2656.832583] IP: [<c046520b>] get_page_from_freelist+0x24b/0x4c0                                        
Mar 12 14:15:02 coyote kernel: [ 2656.832613] *pdpt = 000000003216c001 *pde = 0000000000000000                                           
Mar 12 14:15:02 coyote kernel: [ 2656.832618] Oops: 0000 [#1] PREEMPT SMP                                                                
Mar 12 14:15:02 coyote kernel: [ 2656.832620] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq                                  
Mar 12 14:15:02 coyote kernel: [ 2656.832623] Modules linked in: radeon drm nls_utf8 cifs nfsd lockd nfs_acl auth_rpcgss 
exportfs rfcomm sco bridge stp llc bnep l2cap autofs4 sunrpc ipv6 snd_emu10k1_synth or51132 snd_emux_synth cx88_dvb 
videobuf_dvb snd_seq_virmidi dvb_core snd_seq_midi_emul tuner_simple snd_emu10k1 tuner_types snd_rawmidi snd_ac97_codec 
ac97_bus tda9887 snd_seq_dummy tda8290 snd_seq_oss snd_seq_midi_event snd_seq tuner snd_pcm_oss cx8800 snd_mixer_oss cx8802 
cx88xx snd_pcm snd_seq_device ir_common v4l2_common snd_timer i2c_algo_bit videodev snd_page_alloc snd_util_mem v4l1_compat 
tveeprom snd_hwdep btcx_risc snd firewire_ohci videobuf_dma_sg ftdi_sio usb_storage floppy videobuf_core firewire_core 
forcedeth sr_mod btusb cdrom sg usbserial i2c_nforce2 soundcore crc_itu_t usblp pcspkr joydev bluetooth i2c_core evdev button 
ahci pata_jmicron pata_amd ata_generic pata_acpi sata_nv libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd 
[last unloaded: drm]
Mar 12 14:15:02 coyote kernel: [ 2656.832669]
Mar 12 14:15:02 coyote kernel: [ 2656.832672] Pid: 18877, comm: kmail Not tainted (2.6.29-rc7 #5) System Product Name
Mar 12 14:15:02 coyote kernel: [ 2656.832675] EIP: 0060:[<c046520b>] EFLAGS: 00210202 CPU: 0
Mar 12 14:15:02 coyote kernel: [ 2656.832678] EIP is at get_page_from_freelist+0x24b/0x4c0
Mar 12 14:15:02 coyote kernel: [ 2656.832680] EAX: ffffffff EBX: 80004000 ECX: 00000001 EDX: 00000002
Mar 12 14:15:02 coyote kernel: [ 2656.832682] ESI: c28fc260 EDI: 00000000 EBP: f2168d5c ESP: f2168cfc
Mar 12 14:15:02 coyote kernel: [ 2656.832684]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Mar 12 14:15:02 coyote kernel: [ 2656.832686] Process kmail (pid: 18877, ti=f2168000 task=f22018b0 task.ti=f2168000)
Mar 12 14:15:02 coyote kernel: [ 2656.832688] Stack:
Mar 12 14:15:02 coyote kernel: [ 2656.832689]  00000002 00000044 c28fc060 00000000 f1463ca4 c0744b80 c06d6480 00000002
Mar 12 14:15:02 coyote kernel: [ 2656.832693]  00000000 00000000 001201d2 00000002 00200246 00000001 c06d6900 00000100
Mar 12 14:15:02 coyote kernel: [ 2656.832698]  00000000 80000000 c06d7484 c06d6480 c06d6480 c06d6480 f22018b0 00000129
Mar 12 14:15:02 coyote kernel: [ 2656.832708] Call Trace:
Mar 12 14:15:02 coyote kernel: [ 2656.832710]  [<c04655fe>] ? __alloc_pages_internal+0xae/0x430
Mar 12 14:15:02 coyote kernel: [ 2656.832713]  [<c0472503>] ? __do_fault+0x163/0x410
Mar 12 14:15:02 coyote kernel: [ 2656.832717]  [<c04676b4>] ? __do_page_cache_readahead+0xe4/0x1e0
Mar 12 14:15:02 coyote kernel: [ 2656.832721]  [<c0467a9b>] ? ondemand_readahead+0x15b/0x180
Mar 12 14:15:02 coyote kernel: [ 2656.832724]  [<c0467b38>] ? page_cache_async_readahead+0x78/0x90
Mar 12 14:15:02 coyote kernel: [ 2656.832727]  [<c0461434>] ? generic_file_aio_read+0x314/0x670
Mar 12 14:15:02 coyote kernel: [ 2656.832733]  [<c048a011>] ? do_sync_read+0xd1/0x110
Mar 12 14:15:02 coyote kernel: [ 2656.832735]  [<c0478f80>] ? vma_merge+0x190/0x270
Mar 12 14:15:02 coyote kernel: [ 2656.832738]  [<c043c3c0>] ? autoremove_wake_function+0x0/0x50
Mar 12 14:15:02 coyote kernel: [ 2656.832742]  [<c04039a7>] ? common_interrupt+0x27/0x2c
Mar 12 14:15:02 coyote kernel: [ 2656.832745]  [<c048aac9>] ? vfs_read+0x99/0x140
Mar 12 14:15:02 coyote kernel: [ 2656.832747]  [<c0489f40>] ? do_sync_read+0x0/0x110
Mar 12 14:15:02 coyote kernel: [ 2656.832749]  [<c048ac2d>] ? sys_read+0x3d/0x70
Mar 12 14:15:02 coyote kernel: [ 2656.832752]  [<c040336d>] ? sysenter_do_call+0x12/0x21
Mar 12 14:15:02 coyote kernel: [ 2656.832754] Code: ff 75 d0 9d 89 e0 25 00 f0 ff ff 83 68 14 01 f6 40 08 08 0f 85 30 02 00 00 
8b 1e 89 f2 8b 46 08 8b 7e 10 f6 c7 40 74 03 8b 56 0c <8b> 4a 04 31 d2 85 ff 0f 95 c2 83 c0 01 09 c2 31 c0 85 c9 0f 95
Mar 12 14:15:02 coyote kernel: [ 2656.832781] EIP: [<c046520b>] get_page_from_freelist+0x24b/0x4c0 SS:ESP 0068:f2168cfc
Mar 12 14:15:02 coyote kernel: [ 2656.832789] ---[ end trace 4e78f421815113f4 ]---
================================

And this time whatever kde uses for an alert popped up another stack of them, 
and then kmail went away so I had to kill its last process to get that screen
back & restart kmail.

Call me puzzled.  Not sure if I'll answer, but... :)

David;
That patch you sent, should I take it back out & wait for a better one?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
descramble code needed from software company

