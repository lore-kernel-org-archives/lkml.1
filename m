Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbYBNBJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbYBNBJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765700AbYBNBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:09:10 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60351 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762094AbYBNBJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:09:08 -0500
Date: Thu, 14 Feb 2008 03:08:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix module_update_markers() compile error
Message-ID: <20080214010851.GI12383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with CONFIG_MODULES=n 
caused by commit fb40bd78b0f91b274879cf5db8facd1e04b6052e:

<--  snip  -->

...
  CC      kernel/marker.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c: In function ‘marker_update_probes’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c:627: error: too few arguments to function ‘module_update_markers’
make[2]: *** [kernel/marker.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8d811a4160c6e2cb92391076e0e0b500e1b4a8a2 diff --git a/include/linux/module.h b/include/linux/module.h
index 330bec0..819c4e8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -567,8 +567,7 @@ static inline void print_modules(void)
 {
 }
 
-static inline void module_update_markers(struct module *probe_module,
-		int *refcount)
+static inline void module_update_markers(void)
 {
 }
 

