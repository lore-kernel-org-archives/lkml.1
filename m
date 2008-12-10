Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYLJHeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYLJHeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYLJHd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:33:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:38340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYLJHd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:33:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,746,1220252400"; 
   d="scan'208";a="88502634"
Date: Wed, 10 Dec 2008 15:33:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Baron <jbaron@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] dynamic_printk: add line feed to printk
Message-ID: <20081210073347.GA18737@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append '\n' to two printk messages.
Also cleanup the code to reduce one level of indentation.

Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 lib/dynamic_printk.c |   58 ++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

--- linux-2.6.orig/lib/dynamic_printk.c
+++ linux-2.6/lib/dynamic_printk.c
@@ -277,40 +277,34 @@ static ssize_t pr_debug_write(struct fil
 				dynamic_enabled = DYNAMIC_ENABLED_NONE;
 			}
 			err = 0;
-		} else {
-			if (elem) {
-				if (value && (elem->enable == 0)) {
-					dynamic_printk_enabled |=
-							(1LL << elem->hash1);
-					dynamic_printk_enabled2 |=
-							(1LL << elem->hash2);
-					elem->enable = 1;
-					num_enabled++;
-					dynamic_enabled = DYNAMIC_ENABLED_SOME;
-					err = 0;
-					printk(KERN_DEBUG
-					       "debugging enabled for module %s",
-					       elem->name);
-				} else if (!value && (elem->enable == 1)) {
-					elem->enable = 0;
-					num_enabled--;
-					if (disabled_hash(elem->hash1, true))
-						dynamic_printk_enabled &=
+		} else if (elem) {
+			if (value && (elem->enable == 0)) {
+				dynamic_printk_enabled |= (1LL << elem->hash1);
+				dynamic_printk_enabled2 |= (1LL << elem->hash2);
+				elem->enable = 1;
+				num_enabled++;
+				dynamic_enabled = DYNAMIC_ENABLED_SOME;
+				err = 0;
+				printk(KERN_DEBUG
+					"debugging enabled for module %s\n",
+					elem->name);
+			} else if (!value && (elem->enable == 1)) {
+				elem->enable = 0;
+				num_enabled--;
+				if (disabled_hash(elem->hash1, true))
+					dynamic_printk_enabled &=
 							~(1LL << elem->hash1);
-					if (disabled_hash(elem->hash2, false))
-						dynamic_printk_enabled2 &=
+				if (disabled_hash(elem->hash2, false))
+					dynamic_printk_enabled2 &=
 							~(1LL << elem->hash2);
-					if (num_enabled)
-						dynamic_enabled =
-							DYNAMIC_ENABLED_SOME;
-					else
-						dynamic_enabled =
-							DYNAMIC_ENABLED_NONE;
-					err = 0;
-					printk(KERN_DEBUG
-					       "debugging disabled for module "
-					       "%s", elem->name);
-				}
+				if (num_enabled)
+					dynamic_enabled = DYNAMIC_ENABLED_SOME;
+				else
+					dynamic_enabled = DYNAMIC_ENABLED_NONE;
+				err = 0;
+				printk(KERN_DEBUG
+					"debugging disabled for module %s\n",
+					elem->name);
 			}
 		}
 	}
