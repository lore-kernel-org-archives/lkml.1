Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYK0Krt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYK0Krt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYK0Kda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:33:30 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62942 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYK0Kcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:31 -0500
Message-Id: <20081127103141.798495350@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:31:10 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 50/60] convert ap_bus printks to pr_xxx macros.
Content-Disposition: inline; filename=165-kmsg-ap.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/crypto/ap_bus.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: quilt-2.6/drivers/s390/crypto/ap_bus.c
===================================================================
--- quilt-2.6.orig/drivers/s390/crypto/ap_bus.c
+++ quilt-2.6/drivers/s390/crypto/ap_bus.c
@@ -24,6 +24,9 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define KMSG_COMPONENT "ap"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -1487,12 +1490,13 @@ int __init ap_module_init(void)
 	int rc, i;
 
 	if (ap_domain_index < -1 || ap_domain_index >= AP_DOMAINS) {
-		printk(KERN_WARNING "Invalid param: domain = %d. "
-		       " Not loading.\n", ap_domain_index);
+		pr_warning("%d is not a valid cryptographic domain\n",
+			   ap_domain_index);
 		return -EINVAL;
 	}
 	if (ap_instructions_available() != 0) {
-		printk(KERN_WARNING "AP instructions not installed.\n");
+		pr_warning("The hardware system does not support "
+			   "AP instructions\n");
 		return -ENODEV;
 	}
 	if (ap_interrupts_available()) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

