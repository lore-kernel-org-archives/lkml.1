Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYBDPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYBDPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYBDPmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:42:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36808 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYBDPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:42:42 -0500
Date: Mon, 4 Feb 2008 18:42:15 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] Whine about suspicious return values from module's ->init() hook
Message-ID: <20080204154215.GA26618@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One head-scratching session could be noticeably shorter with this patch...

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/module.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2171,6 +2171,12 @@ sys_init_module(void __user *umod,
 		wake_up(&module_wq);
 		return ret;
 	}
+	if (ret > 0) {
+		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d\n"
+		       KERN_WARNING "%s: loading module anyway...\n",
+		       __func__, mod->name, ret,
+		       __func__);
+	}
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);

