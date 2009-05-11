Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZEKSfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZEKSfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZEKSeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:34:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbZEKSee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:34:34 -0400
Message-ID: <4A086FB8.6020509@garzik.org>
Date: Mon, 11 May 2009 14:34:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: petkovbb@gmail.com, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix suspend/resume for ATA SEMB devices
References: <20090426143836.GA3643@liondog.tnic>
In-Reply-To: <20090426143836.GA3643@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sun, 26 Apr 2009 16:33:34 +0200
> Subject: [PATCH] libata: fix suspend/resume for ATA SEMB devices
> 
> 79b42babbac2a5a522b8e269fb2811b6e1063030 fixed identifying ATA devices
> reporting 3c/c3 signature which belongs to SEMB devices now. However,
> suspending the machine with such device (WDC WD2500AAJS-6 01.0) fails
> with the following:
> 
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/100 mode selected
> hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/66 mode selected
> sd 1:0:0:0: [sda] Starting disk
> ata5: SATA link down (SStatus 0 SControl 300)
> ata1: SATA link down (SStatus 0 SControl 300)
> ata3: SATA link down (SStatus 0 SControl 300)
> ata6: SATA link down (SStatus 0 SControl 300)
> ata2: softreset failed (device not ready)
> ata2: failed due to HW bug, retry pmp=0
> ata4: softreset failed (device not ready)
> ata4: failed due to HW bug, retry pmp=0
> ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: class mismatch 1 != 7
> ata2.00: revalidation failed (errno=-19)
> ata2: limiting SATA link speed to 1.5 Gbps
> ata4.00: configured for UDMA/133
> ata2: softreset failed (device not ready)
> ata2: failed due to HW bug, retry pmp=0
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata2.00: class mismatch 1 != 7
> ata2.00: revalidation failed (errno=-19)
> ata2.00: disabled
> sd 1:0:0:0: rejecting I/O to offline device
> sd 1:0:0:0: [sda] START_STOP FAILED
> sd 1:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
> PM: Device 1:0:0:0 failed to thaw: error 65536
> sd 3:0:0:0: [sdb] Starting disk
> 
> due to a class mismatch in ata_dev_revalidate(). Fix it by adding the
> ATA_DEV_SEMB device class to the check.
> 
> CC: Tejun Heo <htejun@gmail.com>
> CC: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ata/libata-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

applied


