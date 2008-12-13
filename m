Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYLMUVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYLMUVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 15:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYLMUVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 15:21:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:9342 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYLMUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 15:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gqlwLMjRqt39bYatbXphoyKNu6cxaboOX9+SJpe8gqnAv9Ul7vxL9+6hFCwyR5a2oZ
         WdlxuqBuwLTANe+E3GsH6NpropOEu/+/PZM0h4qpFJAG12UJSM/vouoqkGQ+EukT3j7E
         eJcZ2cWpQRWROkEmgBFiec9mRWKCxc+XMO3ds=
Message-ID: <4944194D.3030405@gmail.com>
Date: Sat, 13 Dec 2008 21:21:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: drzeus@drzeus.cx
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] mmc: balanc pci_iomap with pci_iounmap
References: <494417FF.7010501@gmail.com>
In-Reply-To: <494417FF.7010501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balance pci_iomap with pci_iounmap, not iounmap

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Sorry, this is what it should be...

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 1df44d9..d4748a8 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -463,7 +463,7 @@ static int sdricoh_init_mmc(struct pci_dev *pci_dev,
 
 err:
 	if (iobase)
-		iounmap(iobase);
+		pci_iounmap(pci_dev, iobase);
 	if (mmc)
 		mmc_free_host(mmc);
 
