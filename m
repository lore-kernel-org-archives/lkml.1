Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZHNMmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZHNMmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbZHNMmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:42:50 -0400
Received: from www.tglx.de ([62.245.132.106]:49713 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbZHNMms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:42:48 -0400
Message-Id: <20090814123548.161669222@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:42:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 01/11] fs: Make unload_nls() NULL pointer safe
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline;
	filename=fs-make-unload-nls-null-pointer-safe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most callsites of unload_nls() do 
     if (nls)
	   unload_nls(nls);

Check the pointer inside unload_nls() like we do in kfree() so we can
simplify the call sites.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/nls/nls_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/fs/nls/nls_base.c
===================================================================
--- linux-2.6-tip.orig/fs/nls/nls_base.c
+++ linux-2.6-tip/fs/nls/nls_base.c
@@ -270,7 +270,8 @@ struct nls_table *load_nls(char *charset
 
 void unload_nls(struct nls_table *nls)
 {
-	module_put(nls->owner);
+	if (nls)
+		module_put(nls->owner);
 }
 
 static const wchar_t charset2uni[256] = {


