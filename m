Return-Path: <linux-kernel-owner+w=401wt.eu-S1765783AbYF0XHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765783AbYF0XHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764708AbYF0W7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:23 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46081 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764390AbYF0W7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:04 -0400
Message-Id: <20080627225801.529820826@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:07 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
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
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 16/28] PNP: improve resource assignment debug
Content-Disposition: inline; filename=pnp-improve-assign-debug
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
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
