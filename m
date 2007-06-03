Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXFCOPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXFCOPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXFCOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:15:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:26567 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXFCOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type;
        b=GH0UdeKNab+FkcmSaRwvPn5VGv0D0DEws3g7GL5wO/gYla2aKDukRbir257rparjFA9rVkZrClnOQVC2KGxwXyLNjxZKx06XPwPw0oicr3czwCoxSxRDlMaj3FvQP/OgLEeuyOsDGIaKeBZhqdVTHrNtGa/IkoApot4/sPp3+Lg=
Message-ID: <4662CCFB.3030907@gmail.com>
Date: Sun, 03 Jun 2007 08:15:23 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070520)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linux 2.6.21.3] CDRW drive not recognised by PATA (ata_piix)
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------020606060008000203010206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020606060008000203010206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I complained about this very problem months ago.  Tejun Heo responded
with the attached patch which does indeed fix the problem for me.
Unfortunately, this patch hasn't made it into the kernel yet.  I have no
idea why.

--------------020606060008000203010206
Content-Type: text/x-patch;
 name="ata_piix-polling-setxfer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ata_piix-polling-setxfer.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index dc42ba1..6e7775a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -105,7 +105,8 @@ enum {
 	PIIX_FLAG_AHCI		= (1 << 27), /* AHCI possible */
 	PIIX_FLAG_CHECKINTR	= (1 << 28), /* make sure PCI INTx enabled */
 
-	PIIX_PATA_FLAGS		= ATA_FLAG_SLAVE_POSS,
+	PIIX_PATA_FLAGS		= ATA_FLAG_SLAVE_POSS |
+				  ATA_FLAG_SETXFER_POLLING,
 	PIIX_SATA_FLAGS		= ATA_FLAG_SATA | PIIX_FLAG_CHECKINTR,
 
 	/* combined mode.  if set, PATA is channel 0.

--------------020606060008000203010206--
