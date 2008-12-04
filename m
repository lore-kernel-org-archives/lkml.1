Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYLDBAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYLDBAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYLDBA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:00:26 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:58206 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbYLDBAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:00:25 -0500
Date: Thu, 4 Dec 2008 09:00:22 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: rusty@rustcorp.com.au
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fix warning of not used variable
Message-ID: <20081204010022.GB17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix this warning:
kernel/module.c:824: warning: ‘print_unload_info’ defined but not used
print_unload_info() just used when CONFIG_PROC_FS was defined.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 kernel/module.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..20b5d25 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -820,6 +820,7 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	return ret;
 }
 
+#ifdef CONFIG_PROC_FS
 static void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
@@ -842,6 +843,7 @@ static void print_unload_info(struct seq_file *m, struct module *mod)
 	if (!printed_something)
 		seq_printf(m, "-");
 }
+#endif
 
 void __symbol_put(const char *symbol)
 {
@@ -893,11 +895,14 @@ void module_put(struct module *module)
 EXPORT_SYMBOL(module_put);
 
 #else /* !CONFIG_MODULE_UNLOAD */
+
+#ifdef CONFIG_PROC_FS
 static void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	/* We don't know the usage count, or what modules are using. */
 	seq_printf(m, " - -");
 }
+#endif
 
 static inline void module_unload_free(struct module *mod)
 {
-- 
1.5.6.3

-- 
Jianjun Kong | Happy Hacking
HOMEPAGE: http://kongove.cn/
GTALK: kongjianjun@gmail.com
