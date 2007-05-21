Return-Path: <linux-kernel-owner+w=401wt.eu-S1762679AbXEWAIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762679AbXEWAIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbXEWAIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:08:36 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41001 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbXEWAIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:08:34 -0400
Date: Mon, 21 May 2007 15:02:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
Message-ID: <20070521060202.GA14877@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, Indan Zupancic <indan@nul.nu>,
	jeff@garzik.org, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, garyhade@us.ibm.com
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <464B3505.20004@gmail.com> <2229.81.207.0.53.1179592754.squirrel@secure.samage.net> <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464F4A58.2050607@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 09:04:56PM +0200, Tejun Heo wrote:
> Tejun Heo wrote:
> > Yeah, if SCR registers are accessible, 0xff doesn't indicate the device
> > isn't there, so the whole skip-0xff logic probably shouldn't apply in
> > such cases, but we can also achieve pretty good result by just making
> > the first reset tries a bit more aggressive.
> 
> So, here's the patch.
> 
> Paul, can you please test this patch without the previous patch?  Indan,
> this should reduce the resume delay.  Please test.  But you'll still
> feel some added delay compared to 2.6.20 due to the mentioned
> suspend/resume change.
> 
Seems to work ok:

[    0.977254] scsi0 : sata_sil
[    0.980243] scsi1 : sata_sil
[    0.983207] ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
[    0.991183] ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
[    2.578436] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.586828] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
[    2.591596] ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
[    2.598094] ata1.00: 39070080 sectors, multi 0: LBA
[    2.603248] ata1.00: applying bridge limits
[    2.614710] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
[    2.619489] ata1.00: configured for UDMA/100
[    2.933096] ata2: SATA link down (SStatus 0 SControl 310)
[    2.936265] scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5
[    2.945002] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 MB)
[    2.951473] sd 0:0:0:0: [sda] Write Protect is off
