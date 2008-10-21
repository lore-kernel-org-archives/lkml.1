Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYJUNr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYJUNr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYJUNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:47:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:55073 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYJUNrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:47:17 -0400
Date: Tue, 21 Oct 2008 06:47:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: add a sanity check in d_free
Message-ID: <20081021064733.3edb3dac@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

remember that debug session we did at KS? You suggested this patch back
then....


>From 7751eaf30474b8cbfaea64795805a17eab05ac53 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 16 Sep 2008 16:51:17 -0700
Subject: [PATCH] fs: add a sanity check in d_free

we're seeing some corruption in the dentry->d_alias list that
appears like a free of an entry still on the list; this patch
adds a WARN_ON() to catch this scenario, as suggested by Al Viro

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 80e9395..4c39a59 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -69,6 +69,7 @@ struct dentry_stat_t dentry_stat = {
 
 static void __d_free(struct dentry *dentry)
 {
+	WARN_ON(!list_empty(&dentry->d_alias));
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
 	kmem_cache_free(dentry_cache, dentry); 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
