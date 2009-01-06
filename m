Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZAFWRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZAFWRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZAFWNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:31 -0500
Received: from kroah.org ([198.145.64.141]:51199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755290AbZAFWN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/60] dynamic_printk: reduce one level of indentation
Date: Tue,  6 Jan 2009 14:11:31 -0800
Message-Id: <1231279939-32728-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Cleanup pr_debug_write() to reduce one level of indentation.

Cc: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_printk.c |   58 ++++++++++++++++++++++---------------------------
 1 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index 8e30295..165a197 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -277,40 +277,34 @@ static ssize_t pr_debug_write(struct file *file, const char __user *buf,
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
-					       "debugging enabled for module %s\n",
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
-					       "%s\n", elem->name);
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
-- 
1.6.0.4

