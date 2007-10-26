Return-Path: <linux-kernel-owner+w=401wt.eu-S1766003AbXJZXHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766003AbXJZXHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXJZXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:07:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41347 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbXJZXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:07:38 -0400
Date: Sat, 27 Oct 2007 01:08:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [2.6 patch] always export sysctl_{r,w}mem_max
Message-ID: <20071026230807.GE30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with CONFIG_SYSCTL=n:

<--  snip  -->

...
ERROR: "sysctl_rmem_max" [fs/dlm/dlm.ko] undefined!
ERROR: "sysctl_wmem_max" [drivers/net/rrunner.ko] undefined!
ERROR: "sysctl_rmem_max" [drivers/net/rrunner.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
22ea6cd56e4fa844b0b1bbab2542f09eb6c9a5ab 
diff --git a/net/core/sock.c b/net/core/sock.c
index febbcbc..ee1cc4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2004,7 +2004,5 @@ EXPORT_SYMBOL(sock_wmalloc);
 EXPORT_SYMBOL(sock_i_uid);
 EXPORT_SYMBOL(sock_i_ino);
 EXPORT_SYMBOL(sysctl_optmem_max);
-#ifdef CONFIG_SYSCTL
 EXPORT_SYMBOL(sysctl_rmem_max);
 EXPORT_SYMBOL(sysctl_wmem_max);
-#endif

