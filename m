Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0BASZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:25:53 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:36407 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab0BASZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:25:52 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Alan Cox <alan@redhat.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 1/2] irda: unbalanced lock_kernel in irnet_ppp
Date: Mon,  1 Feb 2010 16:21:34 -0200
Message-Id: <1265048496-8149-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing unlock_kernel in one ioctl operation.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 net/irda/irnet/irnet_ppp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index d6b502c..8d38fdd 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -703,7 +703,8 @@ dev_irnet_ioctl(
       lock_kernel();
       if(ap->ppp_open && !put_user(ppp_unit_number(&ap->chan),
 						(int __user *)argp))
-      err = 0;
+        err = 0;
+      unlock_kernel();
       break;
 
       /* All these ioctls can be passed both directly and from ppp_generic,
-- 
1.6.6.1

