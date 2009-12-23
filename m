Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLWBp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLWBp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZLWBpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:45:53 -0500
Received: from ozlabs.org ([203.10.76.45]:38938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZLWBpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:45:45 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/3] of: include linux/proc_fs.h
Message-Id: <1261532718.575422.369701385795.1.gpush@pororo>
In-Reply-To: <1261532718.575048.365032094903.0.gpush@pororo>
To: Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 23 Dec 2009 09:45:18 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a few procfs-specific functions (eg, proc_device_tree_*) which
aren't covered by the current includes. This causes the following build
error on arm:

drivers/of/base.c: In function 'prom_add_property':
drivers/of/base.c:861: error: implicit declaration of function 'proc_device_tree_add_prop'
drivers/of/base.c: In function 'prom_remove_property':
drivers/of/base.c:902: error: implicit declaration of function 'proc_device_tree_remove_prop'
drivers/of/base.c: In function 'prom_update_property':
drivers/of/base.c:946: error: implicit declaration of function 'proc_device_tree_update_prop'

Add proc_fs.h for these prototypes.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/of/base.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 974f64e..2dcb7a3 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
+#include <linux/proc_fs.h>
 
 struct device_node *allnodes;
 
