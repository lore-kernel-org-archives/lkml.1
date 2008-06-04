Return-Path: <linux-kernel-owner+w=401wt.eu-S1762901AbYFDWOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762901AbYFDWOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYFDWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:11:36 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:6041 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625AbYFDWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:32 -0400
Message-Id: <20080604221128.376212230@ldl.fc.hp.com>
References: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:41 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 08/18] PNP: improve resource assignment debug
Content-Disposition: inline; filename=pnp-improve-assign-debug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to assign an I/O or MEM resource, include the min/max
in the debug output to help match it with the options.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/manager.c
===================================================================
--- work10.orig/drivers/pnp/manager.c	2008-05-13 12:01:17.000000000 -0600
+++ work10/drivers/pnp/manager.c	2008-05-13 12:50:57.000000000 -0600
@@ -47,7 +47,10 @@ static int pnp_assign_port(struct pnp_de
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign io %d\n", idx);
+			dev_dbg(&dev->dev, "  couldn't assign io %d "
+				"(min %#llx max %#llx)\n", idx,
+				(unsigned long long) rule->min,
+				(unsigned long long) rule->max);
 			return 0;
 		}
 	}
@@ -96,7 +99,10 @@ static int pnp_assign_mem(struct pnp_dev
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign mem %d\n", idx);
+			dev_dbg(&dev->dev, "  couldn't assign mem %d "
+				"(min %#llx max %#llx)\n", idx,
+				(unsigned long long) rule->min,
+				(unsigned long long) rule->max);
 			return 0;
 		}
 	}

-- 
