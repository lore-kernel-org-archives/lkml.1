Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXDJVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXDJVIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDJVIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:08:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47009 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753872AbXDJVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:08:22 -0400
Date: Tue, 10 Apr 2007 23:08:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make kernel/module.c:is_exported() static
Message-ID: <20070410210829.GJ28370@stusta.de>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm4:
>...
> +fix-race-between-rmmod-and-cat-proc-kallsyms.patch
>...
>  Misc
>...


is_exported() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/module.h |    7 -------
 kernel/module.c        |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.21-rc6-mm1/include/linux/module.h.old	2007-04-10 01:04:03.000000000 +0200
+++ linux-2.6.21-rc6-mm1/include/linux/module.h	2007-04-10 01:05:09.000000000 +0200
@@ -382,8 +382,6 @@
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-int is_exported(const char *name, const struct module *mod);
-
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
@@ -558,11 +556,6 @@
 	return 0;
 }
 
-static inline int is_exported(const char *name, const struct module *mod)
-{
-	return 0;
-}
-
 static inline int register_module_notifier(struct notifier_block * nb)
 {
 	/* no events will happen anyway, so this can always succeed */
--- linux-2.6.21-rc6-mm1/kernel/module.c.old	2007-04-10 01:05:16.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/module.c	2007-04-10 01:05:36.000000000 +0200
@@ -1746,7 +1746,7 @@
 }
 
 #ifdef CONFIG_KALLSYMS
-int is_exported(const char *name, const struct module *mod)
+static int is_exported(const char *name, const struct module *mod)
 {
 	if (!mod && lookup_symbol(name, __start___ksymtab, __stop___ksymtab))
 		return 1;

