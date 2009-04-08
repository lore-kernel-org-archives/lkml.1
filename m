Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbZDHQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbZDHQOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934242AbZDHQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:13:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52087 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934195AbZDHQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:13:38 -0400
Date: Wed, 8 Apr 2009 12:12:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, gnb@sgi.com
Subject: [PATCH] remove pr_fmt() from dynamic_dev_dbg() printk
Message-ID: <20090408161252.GA3125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

When pr_fmt() was added to the pr_debug() code, we added it not only to the
dynamic_pr_debug() function, but also to the dynamic_dev_dbg() funciton.
However, dev_dbg() doesn't make use of pr_fmt(), so neither should
dynamic_dev_dbg().

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 dynamic_debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


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
 
