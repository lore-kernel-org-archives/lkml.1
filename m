Return-Path: <linux-kernel-owner+w=401wt.eu-S964923AbYBNFSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbYBNFSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764871AbYBNFOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:14:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:8020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761359AbYBNFOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kqDgJ37b/VLF2ijBoR9ol92MskJdvZuYaoqaSuY27IDWV+pTd26aZFrkivuKtx7f5Sz5QYnWmPKbN+tIdFsCG/GUs1ze/ShmK5mwfeqZBK+DxTI8cfcY4m+yWZL8OzOH8zmcW+sD45U2WTaI854e5ruOJnrzW3GluzqHbj+fOAI=
Subject: [PATCH 07/11] ata: fix sparse warning in pata_cs5536.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 21:14:23 -0800
Message-Id: <1202966063.2748.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everybody passes in a u32...why fight it.

drivers/ata/pata_cs5536.c:124:26: warning: incorrect type in argument 3 (different signedness)
drivers/ata/pata_cs5536.c:124:26:    expected int *val
drivers/ata/pata_cs5536.c:124:26:    got unsigned int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ata/pata_cs5536.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index d753e56..c71505e 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -85,7 +85,7 @@ static const u8 pci_reg[4] = {
 	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
 };
 
-static inline int cs5536_read(struct pci_dev *pdev, int reg, int *val)
+static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
 		u32 dummy;
-- 
1.5.4.1.1278.gc75be


