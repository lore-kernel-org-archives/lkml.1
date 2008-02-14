Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbYBNAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbYBNAXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933455AbYBNAWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:22:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:24524 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbYBNAWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WYvbzV1l6gPWznovaRfPt2RGfTMPydacehcZVRsTHk0cjn7rKill2MsKJJHYoevS06vSnepwMRfQJMOlp70iKBormmZGvqNQP6frKj/owPNq5kX80D++732RBBDWuh3pF7/+ABLErwAFiU1VAfmw04qKV6FxbvKsz4zq6RJ+cuk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:36:28 +0100
Message-Id: <20080214003628.12879.96439.sendpatchset@localhost.localdomain>
In-Reply-To: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
References: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/11] ide-pmac: remove dead code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused pmac_ide_{check_base,get_irq}() and pmac_find_ide_boot(),
then remove no longer needed ide_majors[] and pmac_ide_count.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   47 -----------------------------------------------
 1 file changed, 47 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -80,7 +80,6 @@ typedef struct pmac_ide_hwif {
 } pmac_ide_hwif_t;
 
 static pmac_ide_hwif_t pmac_ide[MAX_HWIFS];
-static int pmac_ide_count;
 
 enum {
 	controller_ohare,	/* OHare based */
@@ -893,52 +892,6 @@ pmac_ide_get_base(int index)
 	return pmac_ide[index].regbase;
 }
 
-int
-pmac_ide_check_base(unsigned long base)
-{
-	int ix;
-	
- 	for (ix = 0; ix < MAX_HWIFS; ++ix)
-		if (base == pmac_ide[ix].regbase)
-			return ix;
-	return -1;
-}
-
-int
-pmac_ide_get_irq(unsigned long base)
-{
-	int ix;
-
-	for (ix = 0; ix < MAX_HWIFS; ++ix)
-		if (base == pmac_ide[ix].regbase)
-			return pmac_ide[ix].irq;
-	return 0;
-}
-
-static int ide_majors[] = { 3, 22, 33, 34, 56, 57 };
-
-dev_t __init
-pmac_find_ide_boot(char *bootdevice, int n)
-{
-	int i;
-	
-	/*
-	 * Look through the list of IDE interfaces for this one.
-	 */
-	for (i = 0; i < pmac_ide_count; ++i) {
-		char *name;
-		if (!pmac_ide[i].node || !pmac_ide[i].node->full_name)
-			continue;
-		name = pmac_ide[i].node->full_name;
-		if (memcmp(name, bootdevice, n) == 0 && name[n] == 0) {
-			/* XXX should cope with the 2nd drive as well... */
-			return MKDEV(ide_majors[i], 0);
-		}
-	}
-
-	return 0;
-}
-
 /* Suspend call back, should be called after the child devices
  * have actually been suspended
  */
