Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbYBBJ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbYBBJ05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYBBJ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:26:44 -0500
Received: from [211.102.241.196] ([211.102.241.196]:33912 "EHLO mail.yuvad.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYBBJ0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:26:41 -0500
From: "Mao Rui" <maorui@yuvad.com>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
Subject: RE: SATA DOM is not identified by ata_piix module
Date: Sat, 2 Feb 2008 17:25:17 +0800
Message-ID: <001e01c8657d$8c839490$7740a8c0@cmaorui2>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
thread-index: AchleRW5dMQR9rmCQBadaX8hdzqm7gABC70Q
In-Reply-To: <47A42CC7.1080401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

No difference... :-(

Here is the log.

[   26.729011] scsi0 : ata_piix
[   26.729067] scsi1 : ata_piix
[   26.729095] ata1: SATA max UDMA/133 cmd 0x1880 ctl 0x1874 bmdma 0x1860
irq 18
[   26.729097] ata2: SATA max UDMA/133 cmd 0x1878 ctl 0x1870 bmdma 0x1868
irq 18
[   26.894043] ata1.00: ATA-6: WDC WD2500SD-01KCB0, 08.02D08, max UDMA/133
[   26.894046] ata1.00: 488397168 sectors, multi 16: LBA48
[   26.910218] ata1.00: configured for UDMA/133
[   57.043651] ata2.00: qc timeout (cmd 0x91)
[   57.043656] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)
[   57.043659] ata2: failed to recover some devices, retrying in 5 secs
[   92.177684] ata2.00: qc timeout (cmd 0x91)
[   92.177688] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)
[   92.177690] ata2: failed to recover some devices, retrying in 5 secs
[  127.312003] ata2.00: qc timeout (cmd 0x91)
[  127.312007] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x4)
[  127.312010] ata2: failed to recover some devices, retrying in 5 secs
[  132.467196] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500SD-01K
08.0 PQ: 0 ANSI: 5
[  132.472308] Driver 'sd' needs updating - please use bus_type methods
[  132.472389] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059
MB)
[  132.472400] sd 0:0:0:0: [sda] Write Protect is off
[  132.472403] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  132.472416] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  132.472459] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059
MB)
[  132.472466] sd 0:0:0:0: [sda] Write Protect is off
[  132.472468] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  132.472481] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  132.472484]  sda: sda1 sda2 < sda5 >
[  132.512151] sd 0:0:0:0: [sda] Attached SCSI disk

Best regards,

Mao Rui


> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com]
> Sent: Saturday, February 02, 2008 4:42 PM
> To: Mao Rui
> Cc: 'Alan Cox'; linux-kernel@vger.kernel.org
> Subject: Re: SATA DOM is not identified by ata_piix module
> 
> Mao Rui wrote:
> > I tried to nail down when the problem was introduced. I compiled some
> > official kernel release. Here is the result.
> > 2.6.17.14   IDE -- Failed   SATA -- passed
> > 2.6.18   IDE -- Failed   SATA -- failed
> > 2.6.18.8   IDE -- Failed   SATA -- failed
> > 2.6.24-rc7-git6  IDE -- passed   SATA DOM -- failed
> > linux-2.6.24-rc8-git1   IDE -- passed    SATA -- failed
> > All IDE failed reason is xfermode error, and all SATA failure is
IDENTIFY
> > error.
> >
> > As you can find out, the failure of SATA DOM was introduced from kernel
> > 2.6.18.
> >
> > I'm not good at low level driver programming, so I cannot find out the
root
> > cause by myself. But if Alan or someone else needs more info or wants to
> > test the patch, I'm glad to do it in my platform.
> 
> Does the attached patch make any difference?
> 
> --
> tejun


