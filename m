Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZF1VLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZF1VLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZF1VLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:11:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:58396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZF1VLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:11:33 -0400
Message-ID: <4A47DC7D.6020609@kernel.org>
Date: Sun, 28 Jun 2009 14:11:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] pci/dmar: don't complain IOPAIC is not supported
References: <4A47DBD5.6070307@kernel.org>
In-Reply-To: <4A47DBD5.6070307@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


INTR_REMAP handle that type

[Impact: cleanup]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/dmar.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -129,9 +129,13 @@ static int __init dmar_parse_dev_scope(v
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
-		else
-			printk(KERN_WARNING PREFIX
-				"Unsupported device scope\n");
+		else  {
+#ifdef CONFIG_INTR_REMAP
+			if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC)
+#endif
+				printk(KERN_WARNING PREFIX
+					"Unsupported device scope\n");
+		}
 		start += scope->length;
 	}
 	if (*cnt == 0)
