Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZDKUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZDKUH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbZDKUHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:07:16 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:59827 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbZDKUHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:07:14 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 16:07:12 EDT
Date: Sat, 11 Apr 2009 21:36:30 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, alsa-devel@vger.kernel.org
Subject: General protection fault when unloading snd_hda_intel on
	2.6.30-rc1+
Message-ID: <20090411193630.GA16968@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I try on my Vaio VGN-FZ240E, using the latest kernel 2.6.30-rc1-00191-gd848223

   modprobe -r snd_hda_intel
   
I get the following trace (copied from dmesg):

general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1 
Modules linked in: nvram uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_idt 
usbhid snd_hda_intel(-) snd_hda_codec snd_hwdep snd_pcm sr_mod sky2 i2c_i801 iwlagn snd_timer 
sg snd_page_alloc evdev ata_piix ahci libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 9063, comm: modprobe Not tainted 2.6.30-rc1-00191-gd848223 #48 VGN-FZ240E
RIP: 0010:[<ffffffff8044bf90>]  [<ffffffff8044bf90>] input_event+0x40/0xa0
RSP: 0018:ffff88006f283a78  EFLAGS: 00010293
RAX: 0000000000000008 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000007 RSI: 0000000000000005 RDI: 697665646632785c
RBP: ffff88006f283aa8 R08: 0000000004d6f76c R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff805bb97c
R13: 0000000000000005 R14: 697665646632785c R15: 0000000000000000
FS:  00007fc6c1e1c6f0(0000) GS:ffff880001028000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000071bf40 CR3: 000000007e2d4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 9063, threadinfo ffff88006f282000, task ffff88006f206840)
Stack:
 ffff88006f283aa8 0000000000000003 ffffffff805bb97c ffff88007e811cc0
 0000000000000001 0000000000000000 ffff88006f283ae8 ffffffff80475612
 ffff88007f241ae0 0000000000000002 ffff88007d5eb010 0000000000000000
Call Trace:
 [<ffffffff80475612>] snd_jack_report+0x92/0xa0
 [<ffffffffa0160047>] stac92xx_unsol_event+0x2e7/0x5e0 [snd_hda_codec_idt]
 [<ffffffffa015f528>] stac_issue_unsol_event+0x58/0x70 [snd_hda_codec_idt]
 [<ffffffffa0160796>] stac92xx_init+0x186/0x660 [snd_hda_codec_idt]
 [<ffffffffa0160c90>] stac92xx_resume+0x20/0x60 [snd_hda_codec_idt]
 [<ffffffffa013c973>] hda_call_codec_resume+0x53/0x90 [snd_hda_codec]
 [<ffffffffa013ca50>] snd_hda_power_up+0x40/0x70 [snd_hda_codec]
 [<ffffffffa013c2b5>] snd_hda_codec_write+0x45/0xa0 [snd_hda_codec]
 [<ffffffffa013c37a>] restore_pincfgs+0x6a/0xa0 [snd_hda_codec]
 [<ffffffffa013ed75>] snd_hda_codec_free+0x35/0x120 [snd_hda_codec]
 [<ffffffffa01403f8>] snd_hda_bus_free+0x68/0xb0 [snd_hda_codec]
 [<ffffffffa01405e4>] snd_hda_bus_dev_free+0x14/0x20 [snd_hda_codec]
 [<ffffffff80473e61>] snd_device_free+0x71/0xd0
 [<ffffffff80473f24>] snd_device_free_all+0x64/0x70
 [<ffffffff8046e16a>] snd_card_do_free+0x3a/0xd0
 [<ffffffff8046ee39>] snd_card_free+0xa9/0xd0
 [<ffffffffa015031e>] azx_remove+0x18/0x2a [snd_hda_intel]
 [<ffffffff8036506f>] pci_device_remove+0x2f/0x60
 [<ffffffff8040ec8c>] __device_release_driver+0x6c/0xb0
 [<ffffffff8040ed78>] driver_detach+0xa8/0xb0
 [<ffffffff8040de48>] bus_remove_driver+0x98/0xd0
 [<ffffffff8040f357>] driver_unregister+0x47/0x60
 [<ffffffff8036530c>] pci_unregister_driver+0x4c/0xc0
 [<ffffffffa0150304>] alsa_card_azx_exit+0x10/0x12 [snd_hda_intel]
 [<ffffffff8026787b>] sys_delete_module+0x18b/0x240
 [<ffffffff80257be9>] ? up_write+0x9/0x10
 [<ffffffff8020be2b>] system_call_fastpath+0x16/0x1b
Code: 89 5d d8 4c 89 65 e0 49 89 fe 41 89 f5 41 89 cf 83 fe 1f 76 16 48 8b 5d d8 4c 8b 65 
e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 <0f> a3 77 20 19 c0 85 c0 74 e0 48 8d 9f f8 06 00 00 89 55 d0 48 
RIP  [<ffffffff8044bf90>] input_event+0x40/0xa0
 RSP <ffff88006f283a78>
---[ end trace 7fa0517f56c40085 ]---


After that,  'cat /proc/modules' contains this line:

snd_hda_intel 28648 0 - Unloading 0xffffffffa014e000

and the HDA driver never finishes that advertised "Unloading". 

It also stops working, 

[mafra@Pilar:linux-2.6]$ alsamixer
alsamixer: function snd_ctl_open failed for default: No such file or directory

The complete dmesg is available at 

http://www.aei.mpg.de/~crmafra/dmesg_hda_intel.txt

and from lspci -vvnn I see this

00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audio Controller [8086:284b] (rev 03)
        Subsystem: Sony Corporation Vaio VGN-FZ260E [104d:9005]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fc400000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Virtual Channel <?>
        Capabilities: [130] Root Complex Link <?>
        Kernel modules: snd-hda-intel


When the audio is working alsamixer says it is using Sigmatel STAC9872AK.

Anything else I can do to help?
