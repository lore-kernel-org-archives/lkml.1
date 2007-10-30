Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbXJ3Ubt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbXJ3Ubt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXJ3Ubj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:31:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59572 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752960AbXJ3Ubi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:31:38 -0400
Date: Tue, 30 Oct 2007 21:31:36 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Roel Kluin <12o3l@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix drivers/net/wan/lmc/ compilation
Message-ID: <20071030203136.GQ7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/SubmitChecklist, point 1:

<--  snip  -->

...
  CC      drivers/net/wan/lmc/lmc_main.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c: In function ‘lmc_ioctl’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c:239: error: expected expression before ‘else’
...
make[5]: *** [drivers/net/wan/lmc/lmc_main.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d5e92a30491abf073e0a7f4d46b466c7c97f0f61 
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 64eb578..37c52e1 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -234,7 +234,7 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
         if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
-					sizeof(struct lmc_xinfo))) {
+			 sizeof(struct lmc_xinfo)))
 		ret = -EFAULT;
 	else
 		ret = 0;

