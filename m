Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbXKTTJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbXKTTJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757854AbXKTTJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:09:14 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:40103 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXKTTJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IEs/Fu/l33jB8AE92ncsFDVyXC2vfJBSbsPXB7q5NAnOlEwantg4WDQRoJaiP8PY1qY3btepHbQgXL9chb9QeleMaJ4hrb/m2lWwFoTRSs0IozZImymQoquryUcKewjf+dZCp3n2r/mUvn0lGMnEdhDI2qFdw1Syqxa97g57Kvs=
Message-ID: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
Date: Tue, 20 Nov 2007 20:09:09 +0100
From: noah <noah123@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Possibly SATA related freeze killed networking and RAID
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a strange freeze that killed networking and made software
RAID fail two of my harddisks.

There are a bunch of messages from the kernel which I extracted from
the system log after reboot at the end of this mail. I hit power off
in pure paranoia after the box froze, and then started to do disk I/O
again just right after I noticed the messages about two of my RAID
disks had failed on the console.
The network didn't recover when the harddrive suddenly started working again.
I managed to connect an USB keyboard and wake up the monitor from
sleep so I could see some of the messages printed on the console.

I looked through some other threads and found a mention of
smartmontools which I too use (5.37-5ubuntu2).

Kernel 2.6.22-14-generic (Ubuntu Gutsy Gibbon 7.10)
Motherboard: Asus M2N32 WS Professional nForce 590 SLI MCP (MCP55)
CPU: Athlon64 X2 Dual-Core 5600+
RAM: 4GB (passed memtest86 just a few minutes ago)

The harddrives are four Samsung HD501LJ 500GB drives.
sda and sdb have firmware CR100-10 and sdc and sdd have firmware CR100-11.
The drives are just a couple of months old, well cooled and so far
there's nothing interesting reported by S.M.A.R.T.

Software raid is configured like this:
sda1,sdc1 -> md0 (raid 1)
sdb1,sdd1 -> md1 (raid 1)
Both md0 and md1 are then encrypted with dm-crypt and the dm-devices
are then used to form md2 (stripe).

  -- noah


# lspci
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:08.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:09.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:09.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:09.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
00:0a.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:0a.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
00:10.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:11.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:12.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:14.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:15.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:16.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:17.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS (rev a1)
02:06.0 Communication controller: Tiger Jet Network Inc. Tiger3XX
Modem/ISDN interface
03:00.0 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X
Bridge (rev 06)
03:00.1 PCI bridge: NEC Corporation uPD720400 PCI Express - PCI/PCI-X
Bridge (rev 06)
08:00.0 RAID bus controller: Marvell Technology Group Ltd. 88SE6145
SATA II PCI-E controller (rev a1)



 kernel: [734344.717844] irq 21: nobody cared (try booting with the
"irqpoll" option)
 kernel: [734344.717866]
 kernel: [734344.717866] Call Trace:
 kernel: [734344.717868]  <IRQ>  [__report_bad_irq+30/128]
__report_bad_irq+0x1e/0x80
 mdadm: Fail event detected on md device /dev/md1, component device /dev/sdd1
 kernel: [734344.717888]  [note_interrupt+643/704] note_interrupt+0x283/0x2c0
 kernel: [734344.717895]  [handle_fasteoi_irq+221/272]
handle_fasteoi_irq+0xdd/0x110
 mdadm: Fail event detected on md device /dev/md0, component device /dev/sdc1
 kernel: [734344.717901]  [do_IRQ+123/256] do_IRQ+0x7b/0x100
 kernel: [734344.717904]  [default_idle+0/64] default_idle+0x0/0x40
 kernel: [734344.717907]  [ret_from_intr+0/10] ret_from_intr+0x0/0xa
 kernel: [734344.717909]  <EOI>  [tcp_poll+0/368] tcp_poll+0x0/0x170
 kernel: [734344.717918]  [default_idle+41/64] default_idle+0x29/0x40
 kernel: [734344.717923]  [cpu_idle+112/192] cpu_idle+0x70/0xc0
 kernel: [734344.717936]
 kernel: [734344.717937] handlers:
 kernel: [734344.717950] [_end+131265960/2130332920]
(nv_generic_interrupt+0x0/0xe0 [sata_nv])
 kernel: [734344.717973] [_end+131152728/2130332920]
(nv_nic_irq_optimized+0x0/0x2b0 [forcedeth])
 kernel: [734344.718003] Disabling IRQ #21
 kernel: [734356.827155] ata5.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x2 frozen
 kernel: [734356.827169] ata5.00: cmd
25/00:90:ff:3c:82/00:01:02:00:00/e0 tag 0 cdb 0x0 data 204800 in
 kernel: [734356.827170]          res
40/00:b4:cc:88:7f/40:00:02:00:00/e0 Emask 0x4 (timeout)
 kernel: [734355.620185] ata6.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x2 frozen
 kernel: [734355.620199] ata6.00: cmd
c8/00:08:ef:52:a9/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
 kernel: [734355.620200]          res
40/00:00:02:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
 kernel: [734355.731595] ata6: soft resetting port
 kernel: [734355.787308] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 kernel: [734358.738407] ata5: port is slow to respond, please be
patient (Status 0xd8)
 kernel: [734360.418260] ata5: device not ready (errno=-16), forcing hardreset
 kernel: [734360.418262] ata5: hard resetting port
 kernel: [734360.643958] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 kernel: [734366.509226] ata6.00: qc timeout (cmd 0x27)
 kernel: [734366.509231] ata6.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734366.509241] ata6.00: failed to set xfermode (err_mask=0x40)
 kernel: [734366.509250] ata6: failed to recover some devices,
retrying in 5 secs
 kernel: [734368.296234] ata6: hard resetting port
 kernel: [734368.521935] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 kernel: [734371.365916] ata5.00: qc timeout (cmd 0x27)
 kernel: [734371.365921] ata5.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734371.365928] ata5.00: failed to set xfermode (err_mask=0x40)
 kernel: [734371.365936] ata5: failed to recover some devices,
retrying in 5 secs
 kernel: [734373.152942] ata5: hard resetting port
 kernel: [734373.378644] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 kernel: [734379.244112] ata6.00: qc timeout (cmd 0x27)
 kernel: [734379.244118] ata6.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734379.244126] ata6.00: failed to set xfermode (err_mask=0x40)
 kernel: [734379.244135] ata6: limiting SATA link speed to 1.5 Gbps
 kernel: [734379.244138] ata6.00: limiting speed to UDMA/133:PIO3
 kernel: [734379.244140] ata6: failed to recover some devices,
retrying in 5 secs
 kernel: [734381.031138] ata6: hard resetting port
 kernel: [734381.256840] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
 kernel: [734384.095108] ata5.00: qc timeout (cmd 0x27)
 kernel: [734384.095113] ata5.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734384.095120] ata5.00: failed to set xfermode (err_mask=0x40)
 kernel: [734384.095129] ata5: limiting SATA link speed to 1.5 Gbps
 kernel: [734384.095131] ata5.00: limiting speed to UDMA/133:PIO3
 kernel: [734384.095133] ata5: failed to recover some devices,
retrying in 5 secs
 kernel: [734385.882133] ata5: hard resetting port
 kernel: [734386.107836] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
 kernel: [734391.979018] ata6.00: qc timeout (cmd 0x27)
 kernel: [734391.979024] ata6.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734391.979032] ata6.00: failed to set xfermode (err_mask=0x40)
 kernel: [734391.979041] ata6.00: disabled
 kernel: [734392.159007] ata6: EH complete
 kernel: [734392.159018] sd 5:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734392.159022] end_request: I/O error, dev sdd, sector 11096815
 kernel: [734392.159026] raid1: sdd1: rescheduling sector 11096752
 kernel: [734394.574692] sd 5:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734394.574697] end_request: I/O error, dev sdd, sector 976767935
 kernel: [734394.574703] md: super_written gets error=-5, uptodate=0
 kernel: [734394.574706] raid1: Disk failure on sdd1, disabling device.
 kernel: [734394.574707] ^IOperation continuing on 1 devices
 kernel: [734394.574960] sd 5:0:0:0: [sdd] READ CAPACITY failed
 kernel: [734394.574961] sd 5:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734394.574964] sd 5:0:0:0: [sdd] Sense not available.
 kernel: [734394.575233] sd 5:0:0:0: [sdd] Write Protect is off
 kernel: [734394.575235] sd 5:0:0:0: [sdd] Mode Sense: 00 00 00 00
 kernel: [734394.575275] sd 5:0:0:0: [sdd] Asking for cache data failed
 kernel: [734394.575282] sd 5:0:0:0: [sdd] Assuming drive cache: write through
 kernel: [734394.577622] RAID1 conf printout:
 kernel: [734394.577624]  --- wd:1 rd:2
 kernel: [734394.577626]  disk 0, wo:1, o:0, dev:sdd1
 kernel: [734394.577627]  disk 1, wo:0, o:1, dev:sdb1
 kernel: [734394.583008] RAID1 conf printout:
 kernel: [734394.583010]  --- wd:1 rd:2
 kernel: [734394.583011]  disk 1, wo:0, o:1, dev:sdb1
 kernel: [734394.593189] raid1: sdb1: redirecting sector 11096752 to
another mirror
 kernel: [734399.802574] ata5.00: qc timeout (cmd 0x27)
 kernel: [734399.802580] ata5.00: ata_hpa_resize 1: hpa sectors (0) is
smaller than sectors (976773168)
 kernel: [734399.802588] ata5.00: failed to set xfermode (err_mask=0x40)
 kernel: [734399.802606] ata5.00: disabled
 kernel: [734400.306547] ata5: EH complete
 kernel: [734400.306601] sd 4:0:0:0: [sdc] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734400.306605] end_request: I/O error, dev sdc, sector 42089727
 kernel: [734400.306608] raid1: sdc1: rescheduling sector 42089664
 kernel: [734400.306626] raid1: sdc1: rescheduling sector 42089672
 kernel: [734400.306642] raid1: sdc1: rescheduling sector 42089680
 kernel: [734400.306658] raid1: sdc1: rescheduling sector 42089688
 kernel: [734400.306674] raid1: sdc1: rescheduling sector 42089696
 kernel: [734400.306690] raid1: sdc1: rescheduling sector 42089704
 kernel: [734400.306706] raid1: sdc1: rescheduling sector 42089712
 kernel: [734400.306722] raid1: sdc1: rescheduling sector 42089720
 kernel: [734400.306738] raid1: sdc1: rescheduling sector 42089728
 kernel: [734400.307304] sd 4:0:0:0: [sdc] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734400.307307] end_request: I/O error, dev sdc, sector 976767935
 kernel: [734400.307313] md: super_written gets error=-5, uptodate=0
 kernel: [734400.307315] raid1: Disk failure on sdc1, disabling device.
 kernel: [734400.307316] ^IOperation continuing on 1 devices
 kernel: [734400.307643] sd 4:0:0:0: [sdc] READ CAPACITY failed
 kernel: [734400.307645] sd 4:0:0:0: [sdc] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
 kernel: [734400.307647] sd 4:0:0:0: [sdc] Sense not available.
 kernel: [734400.307767] sd 4:0:0:0: [sdc] Write Protect is off
 kernel: [734400.307768] sd 4:0:0:0: [sdc] Mode Sense: 00 00 00 00
 kernel: [734400.307947] sd 4:0:0:0: [sdc] Asking for cache data failed
 kernel: [734400.307963] sd 4:0:0:0: [sdc] Assuming drive cache: write through
 kernel: [734400.319399] RAID1 conf printout:
 kernel: [734400.319401]  --- wd:1 rd:2
 kernel: [734400.319402]  disk 0, wo:1, o:0, dev:sdc1
 kernel: [734400.319404]  disk 1, wo:0, o:1, dev:sda1
 kernel: [734400.330537] RAID1 conf printout:
 kernel: [734400.330539]  --- wd:1 rd:2
 kernel: [734400.330540]  disk 1, wo:0, o:1, dev:sda1
