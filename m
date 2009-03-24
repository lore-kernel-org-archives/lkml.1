Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZCXWET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZCXWET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZCXWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:04:05 -0400
Received: from wbmler1.mail.xerox.com ([13.13.138.216]:38453 "EHLO
	wbmler1.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZCXWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:04:04 -0400
X-Greylist: delayed 1067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 18:04:04 EDT
X-XeroxINT-Source-Ip: 13.62.6.81
X-XeroxINT-Source-Name: hermes.opbu.xerox.com
X-XeroxINT-Reported-Name: hermes.opbu.xerox.com
Message-Id: <200903242146.n2OLkBQr004582@pogo.cesa.opbu.xerox.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/module.c: fix compiler warning if CONFIG_SMP=n
Date: Tue, 24 Mar 2009 14:46:11 -0700
From: Andrew Klossner <andrew@cesa.opbu.xerox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6e2b7574 causes this new compiler warning if
CONFIG_MODULE_UNLOAD=n or CONFIG_SMP=n:

kernel/module.c:2291: warning: label 'free_init' defined but not used

To fix, move the label inside the #if/#endif.

Signed-off-by: Andrew Klossner <andrew@cesa.opbu.xerox.com>
---
diff --git a/kernel/module.c b/kernel/module.c
index 1196f5d..df00a1b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2288,8 +2288,8 @@ static noinline struct module *load_module(void __user *umod,
 	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
- free_init:
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+ free_init:
 	percpu_modfree(mod->refptr);
 #endif
 	module_free(mod, mod->module_init);
