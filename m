Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab0CKSIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:08:50 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43634 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826Ab0CKSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:07:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 34/37] sound/sparc: use .dev.of_node instead of .node in
	struct of_device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:06:55 -0700
Message-ID: <20100311180655.4824.33693.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.node is being removed

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 sound/sparc/cs4231.c |    6 +++---
 sound/sparc/dbri.c   |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
index 8d13d93..14cb87c 100644
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -2076,12 +2076,12 @@ static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_dev
 static int __devinit cs4231_probe(struct of_device *op, const struct of_device_id *match)
 {
 #ifdef EBUS_SUPPORT
-	if (!strcmp(op->node->parent->name, "ebus"))
+	if (!strcmp(op->dev.of_node->parent->name, "ebus"))
 		return cs4231_ebus_probe(op, match);
 #endif
 #ifdef SBUS_SUPPORT
-	if (!strcmp(op->node->parent->name, "sbus") ||
-	    !strcmp(op->node->parent->name, "sbi"))
+	if (!strcmp(op->dev.of_node->parent->name, "sbus") ||
+	    !strcmp(op->dev.of_node->parent->name, "sbi"))
 		return cs4231_sbus_probe(op, match);
 #endif
 	return -ENODEV;
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 1d2e51b..2734c36 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2650,7 +2650,7 @@ static int __devinit dbri_probe(struct of_device *op, const struct of_device_id
 
 	printk(KERN_INFO "audio%d at %p (irq %d) is DBRI(%c)+CS4215(%d)\n",
 	       dev, dbri->regs,
-	       dbri->irq, op->node->name[9], dbri->mm.version);
+	       dbri->irq, op->dev.of_node->name[9], dbri->mm.version);
 	dev++;
 
 	return 0;

