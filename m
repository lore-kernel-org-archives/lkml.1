Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZDFNPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZDFNPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbZDFNPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:15:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZDFNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kHIY3FHucw7b75PsbgjZpr+njGyGsYUjzMUi65pvqvHSxgDt8NOhFREZmPs1UAODdU
         fLmYhtx+LwDXI8A9CM6ZFgGzxvx1kWCwEj8iSoZjJXgaqWdRPiLuy+0CPwgiQegb8M6m
         PPPsxhFHSSDg0HiFeumYDFaEEKfuWkC/m/Egw=
Date: Mon, 6 Apr 2009 17:14:44 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: kees.cook@canonical.com, serue@us.ibm.com, jmorris@namei.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH next] module.c: fix build breakage when !MODULE_UNLOAD
Message-ID: <20090406131444.GA3928@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_MODULE_UNLOAD is not set:
kernel/module.c: In function 'sys_init_module':
kernel/module.c:2401: error: 'modules_disabled' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 kernel/module.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 274ab43..5fb0ece 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -73,6 +73,9 @@ DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
+/* Block module loading/unloading? */
+int modules_disabled = 0;
+
 /* Waiting for a module to finish initializing? */
 static DECLARE_WAIT_QUEUE_HEAD(module_wq);
 
@@ -782,9 +785,6 @@ static void wait_for_zero_refcount(struct module *mod)
 	mutex_lock(&module_mutex);
 }
 
-/* Block module loading/unloading? */
-int modules_disabled = 0;
-
 SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		unsigned int, flags)
 {
