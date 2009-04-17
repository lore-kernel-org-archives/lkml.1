Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZDQTKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZDQTKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZDQTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:32 -0400
Received: from kroah.org ([198.145.64.141]:51227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755267AbZDQTHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] Driver core: remove pr_fmt() from dynamic_dev_dbg() printk
Date: Fri, 17 Apr 2009 12:04:33 -0700
Message-Id: <1239995074-4065-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

When pr_fmt() was added to the pr_debug() code, we added it not only to the
dynamic_pr_debug() function, but also to the dynamic_dev_dbg() funciton.
However, dev_dbg() doesn't make use of pr_fmt(), so neither should
dynamic_dev_dbg().

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/dynamic_debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index baabf33..a0d9422 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -70,7 +70,7 @@ extern int ddebug_remove_module(char *mod_name);
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
 			dev_printk(KERN_DEBUG, dev,			\
-					KBUILD_MODNAME ": " pr_fmt(fmt),\
+					KBUILD_MODNAME ": " fmt,	\
 					##__VA_ARGS__);			\
 	} while (0)
 
-- 
1.6.2

