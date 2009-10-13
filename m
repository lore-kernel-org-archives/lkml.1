Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZJMPBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZJMPBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbZJMPBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:01:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40493 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760147AbZJMPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:01:00 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] sep: Fix build problems from header changes
To: gregk@kroah.com, linux-kernel@vger.kernel.org, arndbergmann@googlemail.com
Date: Tue, 13 Oct 2009 15:48:51 +0100
Message-ID: <20091013144844.31420.88150.stgit@localhost.localdomain>
In-Reply-To: <20091013144716.31420.47979.stgit@localhost.localdomain>
References: <20091013144716.31420.47979.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 87f8a11..2ecd62d 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -35,6 +35,7 @@
 #include <linux/cdev.h>
 #include <linux/kdev_t.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/poll.h>
 #include <linux/wait.h>
@@ -272,7 +273,8 @@ static dma_addr_t sep_shared_virt_to_bus(struct sep_device *sep,
 						void *virt_address)
 {
 	dma_addr_t pa = sep->shared_bus + (virt_address - sep->shared_addr);
-	edbg("sep: virt to bus b %08llx v %p\n", pa, virt_address);
+	edbg("sep: virt to bus b %08llx v %p\n", (unsigned long long) pa,
+								virt_address);
 	return pa;
 }
 
@@ -1769,7 +1771,7 @@ static struct sep_flow_context_t *sep_find_flow_context(struct sep_device *sep,
 static int sep_create_flow_dma_tables_handler(struct sep_device *sep,
 							unsigned long arg)
 {
-	int error;
+	int error = -ENOENT;
 	struct sep_driver_build_flow_table_t command_args;
 	/* first table - output */
 	struct sep_lli_entry_t first_table_data;

