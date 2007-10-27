Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXJ0Cej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXJ0Cej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXJ0Ce3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:34:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38428 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbXJ0Ce2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:34:28 -0400
Date: Sat, 27 Oct 2007 04:34:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] net/ipv{4,6}/esp{4,6}.c must #include
	<linux/scatterlist.h>
Message-ID: <20071027023448.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile errors in some configurations:

<--  snip  -->

...
  CC      net/ipv4/esp4.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/esp4.c: In function 'esp_output':
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/esp4.c:113: error: implicit declaration of function 'sg_init_table'
make[3]: *** [net/ipv4/esp4.o] Error 1
...
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv6/esp6.c: In function 'esp6_output':
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv6/esp6.c:112: error: implicit declaration of function 'sg_init_table'
make[3]: *** [net/ipv6/esp6.o] Error 1


<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 net/ipv4/esp4.c |    2 +-
 net/ipv6/esp6.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

ecf93220d6af83516dbe04dcd09474a0423ce2ef 
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index ba98401..23b647c 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -3,7 +3,7 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index f67d51a..f8bb136 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -29,7 +29,7 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>

