Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959AbZICEAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbZICEAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 00:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbZICEAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 00:00:14 -0400
Received: from gherkin.frus.com ([192.158.254.49]:42102 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbZICEAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 00:00:13 -0400
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 00:00:13 EDT
Date: Wed, 2 Sep 2009 22:39:45 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.31-rc8 readcd Oops
Message-ID: <20090903033945.GA20755@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to catch this so late in the -rc cycle, but I haven't burned any
CDs in a *long* time...

Fired up "xcdroast" to duplicate a CD, and promptly got the following
Oops:

  BUG: unable to handle kernel NULL pointer dereference at 00000004
  IP: [<c105c064>] __free_pages+0x10/0x59
  *pde = 00000000 
  Oops: 0002 [#1] PREEMPT 
  last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource
  Modules linked in: sg snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus usbhid snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore af_packet ipv6 uhci_hcd ehci_hcd usbcore binfmt_misc
  
  Pid: 20682, comm: readcd Not tainted (2.6.31-rc8 #1) 
  EIP: 0060:[<c105c064>] EFLAGS: 00010246 CPU: 0
  EIP is at __free_pages+0x10/0x59
  EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00000002
  ESI: 00000004 EDI: 00004000 EBP: 00004000 ESP: d3b61ddc
   DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
  Process readcd (pid: 20682, ti=d3b60000 task=d4cd6500 task.ti=d3b60000)
  Stack:
   85ab3aa0 d882aa21 ffffc000 d390f01c 00000001 00000080 00000002 00004220
  <0> 00008000 00008000 85ab3aa0 00008000 d390f01c d390f000 00000000 d882aa9d
  <0> 85ab3aa0 d390f000 d4d89de0 00000246 d882bd33 d39e1420 00000000 d3b61e6c
  Call Trace:
   [<d882aa21>] ? sg_build_indirect+0x243/0x272 [sg]
   [<d882aa9d>] ? sg_build_reserve+0x4d/0x78 [sg]
   [<d882bd33>] ? sg_open+0x33b/0x415 [sg]
   [<c107e3b8>] ? exact_match+0x0/0x23
   [<c107ee04>] ? chrdev_open+0x16b/0x197
   [<c107ec99>] ? chrdev_open+0x0/0x197
   [<c1079d31>] ? __dentry_open+0x143/0x23e
   [<c107ac8d>] ? nameidata_to_filp+0x36/0x5b
   [<c108753e>] ? do_filp_open+0x441/0x7e5
   [<c101d07b>] ? __wake_up+0x38/0x84
   [<c1030473>] ? queue_work_on+0x32/0x4d
   [<c1079a82>] ? do_sys_open+0x5a/0x107
   [<c1079ba1>] ? sys_open+0x2c/0x43
   [<c1002b3c>] ? syscall_call+0x7/0xb
  Code: 31 d2 8b 14 24 65 33 15 14 00 00 00 74 05 e8 4c 49 fc ff 59 31 d2 e9 d1 fd ff ff 83 ec 04 89 c1 65 a1 14 00 00 00 89 04 24 31 c0 <ff> 49 04 0f 94 c0 84 c0 74 2c 85 d2 75 14 8b 04 24 65 33 05 14 
  EIP: [<c105c064>] __free_pages+0x10/0x59 SS:ESP 0068:d3b61ddc
  CR2: 0000000000000004
  ---[ end trace 80d0523f259c41c8 ]---

This is a SCSI system.  The PIONEER CD-ROM drive below is the one that
was being accessed when the Oops occurred.  The HA is an Adaptec 2930U2
(aic7xxx driver).

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: WDIGTL   Model: WDE18300 ULTRA2  Rev: 1.30
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: SX118273LC       Rev: 6367
  Type:   Direct-Access                    ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: PIONEER  Model: CD-ROM DR-U24X   Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: YAMAHA   Model: CRW2200S         Rev: 1.0D
  Type:   CD-ROM                           ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: EXABYTE  Model: EXB-82058VQANXR1 Rev: 07T0
  Type:   Sequential-Access                ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: RICOH    Model: IS60             Rev: 2R02
  Type:   Scanner                          ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: ARCHIVE  Model: VIPER 2525 25462 Rev: -007
  Type:   Sequential-Access                ANSI  SCSI revision: 01

-- 
------------------------------------------------------------------------
Bob Tracy          |  "Every normal man must be tempted at times to spit
rct@frus.com       |   upon his hands, hoist the black flag, and begin
                   |   slitting throats."	-- H.L. Mencken
------------------------------------------------------------------------
