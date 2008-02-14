Return-Path: <linux-kernel-owner+w=401wt.eu-S964999AbYBNFSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbYBNFSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764947AbYBNFOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:8020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763553AbYBNFO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RSjliCNhdSdAQwj+pmIePDPK+ZDGIuK1uB1uIFRR46X0fczi8UVh4aqLwfGUuXWukEgQdzFRr94zh2ZnW9U47vdWQ1+D5lfOTYOf5zbbemMy3S264kPrkyLbKo/866D6e01uNTajsUb5OwU2M7zSNRKt6Yvg7LCwI9MRrSmKcW0=
Subject: [PATCH 08/11] ata: fix sparse warning in pata_jmicron.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:26 -0800
Message-Id: <1202966066.2748.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/ata/pata_jmicron.c:118:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/pata_jmicron.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 5b8174d..00bbbbd 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -115,7 +115,8 @@ static int jmicron_pre_reset(struct ata_link *link, unsigned long deadline)
 
 static void jmicron_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, jmicron_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, jmicron_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /* No PIO or DMA methods needed for this device */
-- 
1.5.4.1.1278.gc75be


