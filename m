Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbYDGVWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbYDGVWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYDGVWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:22:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:60723 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYDGVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JWcyVBIzASfOanCaeo8YvQ8Ei6tUzXlJJtzh0Z4Ze6ky1PXO/bBF2nQ4x9LUz3hDsnGtJQFFdrMnb1EK+sxPI/PdrPufngDcmIwLmQXGyGO9PRSI0i3ZkRN2QDZZyJ/1db80PfSsYJmKLKgg7u7r/Y4JqRS9/45hdGdV/mzfBhE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Mon, 7 Apr 2008 23:32:34 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804072332.34811.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- make siimage driver work on PPC 44x
  (Sergei Shtylyov & Valentine Barshak)

Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/pci/siimage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Sergei Shtylyov (1):
      siimage: fix kernel oops on PPC 44x


diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index cc4be96..8d624af 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -492,7 +492,7 @@ static void proc_reports_siimage (struct pci_dev *dev, u8 clocking, const char *
  
 static unsigned int setup_mmio_siimage (struct pci_dev *dev, const char *name)
 {
-	unsigned long bar5	= pci_resource_start(dev, 5);
+	resource_size_t bar5	= pci_resource_start(dev, 5);
 	unsigned long barsize	= pci_resource_len(dev, 5);
 	u8 tmpbyte	= 0;
 	void __iomem *ioaddr;
