Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYFENpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYFENpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYFENpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:45:11 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:48817 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYFENpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:45:10 -0400
Date: Thu, 5 Jun 2008 14:44:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeff Garzik <jeff@garzik.org>
cc: Olaf Hering <olaf@aepfle.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: fix G5 SATA broken on -rc5
In-Reply-To: <20080605135444.7a1e5158@core>
Message-ID: <Pine.LNX.4.64.0806051436180.5315@blonde.site>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
 <20080605112436.GA4533@aepfle.de> <Pine.LNX.4.64.0806051255340.28792@blonde.site>
 <20080605135444.7a1e5158@core>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix G5 SATA irq 18: nobody cared, reported on -rc5 by Olaf Hering:
fixlet to a57c1bade5a0ee5cd8b74502db9cbebb7f5780b2 libata-sff:
Fix oops reported in kerneloops.org for pnp devices with no ctl
    
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/ata/libata-sff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.26-rc5/drivers/ata/libata-sff.c	2008-06-05 07:18:07.000000000 +0100
+++ linux/drivers/ata/libata-sff.c	2008-06-05 12:42:39.000000000 +0100
@@ -278,7 +278,7 @@ static u8 ata_sff_irq_status(struct ata_
 		    	return status;
 	}
 	/* Clear INTRQ latch */
-	status = ata_sff_check_status(ap);
+	status = ap->ops->sff_check_status(ap);
 	return status;
 }
 
