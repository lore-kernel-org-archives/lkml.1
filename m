Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXCEFTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXCEFTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 00:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXCEFTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 00:19:12 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:56614 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXCEFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 00:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=KdD6hYUFGtiCrxGWii163LrGm5EGBd7FZ/WzRPy7+HIui/CmOO5EbmAcVTxLTuLHivqNTz7g2uHkgdk7mFBR0kQxRH826yex1j9j1uVPtxqoF6FsxSy/UvgPyCC40pHJShhJnETZ2rcmbcnIe0ipZpsaoS+eE0C03/YTTx0xzeY=
Message-ID: <45EBA84C.2020304@gmail.com>
Date: Mon, 05 Mar 2007 14:19:08 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <00e301c75dc5$693f3900$2101a8c0@donald>
In-Reply-To: <00e301c75dc5$693f3900$2101a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------090301020000010200050802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090301020000010200050802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Paul Rolland wrote:
> Hello,
> 
> Applied this on top of 2.6.21-rc1 and your previous patch (see my previous
> mail). 
> Still booting, no more the weird error I've reported minutes ago.
> 
> pata_jmicron still unable to detect my DVD-RW :
> scsi8 : pata_jmicron
> ata9.00: ATAPI, max UDMA/66
> ata9.00: qc timeout (cmd 0xef)
> ata9.00: failed to set xfermode (err_mask=0x4)
> ata9.00: limiting speed to UDMA/44
> ata9: failed to recover some devices, retrying in 5 secs
> ata9.00: qc timeout (cmd 0xef)
> ata9.00: failed to set xfermode (err_mask=0x4)
> ata9.00: limiting speed to PIO0
> ata9: failed to recover some devices, retrying in 5 secs
> ata9.00: qc timeout (cmd 0xef)
> ata9.00: failed to set xfermode (err_mask=0x4)
> ata9.00: disabled
> scsi9 : pata_jmicron
> ATA: abnormal status 0x7F on port 0x0000000000019807

1. Has it ever worked with the previous kernels?

2. If you connect a harddisk to pata_jmicron, does it work?

3. Does applying the attached patch fix your problem?

-- 
tejun

--------------090301020000010200050802
Content-Type: text/x-patch;
 name="pata_jmicron-polling-xfer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pata_jmicron-polling-xfer.patch"

diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 43763c9..8a95a56 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -196,7 +196,8 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 {
 	static struct ata_port_info info = {
 		.sht		= &jmicron_sht,
-		.flags	= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags	= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST |
+			  ATA_FLAG_SETXFER_POLLING,
 
 		.pio_mask	= 0x1f,
 		.mwdma_mask	= 0x07,

--------------090301020000010200050802--
