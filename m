Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbYDTRQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbYDTRQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYDTRPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:15:54 -0400
Received: from khc.piap.pl ([195.187.100.11]:39551 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYDTRPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:15:53 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] Removing dead code in /drivers/net/wan/hdlc_fr.c
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 20 Apr 2008 19:15:51 +0200
Message-ID: <m3lk385tx4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cédric Augonnet <Cedric.Augonnet@ens-lyon.fr>

Removing dead code in /drivers/net/wan/hdlc_fr.c
    
The local variable "prefix" is never used anymore, and the content of
this string appears a bit later, directly in a call to "alloc_netdev"
after doing exactly the same if/else test. So there seems to be no
point keeping those 4 lines anymore.
    
Signed-off-by: Cédric Augonnet <cedric.augonnet@ens-lyon.org>
Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index c4ab032..520bb0b 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1090,10 +1090,6 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	pvc_device *pvc = NULL;
 	struct net_device *dev;
 	int result, used;
-	char * prefix = "pvc%d";
-
-	if (type == ARPHRD_ETHER)
-		prefix = "pvceth%d";
 
 	if ((pvc = add_pvc(frad, dlci)) == NULL) {
 		printk(KERN_WARNING "%s: Memory squeeze on fr_add_pvc()\n",
