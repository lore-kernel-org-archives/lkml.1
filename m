Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbXGaUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbXGaUjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934383AbXGaUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:37:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934378AbXGaUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FM2vYCdsxn9kAK0E+sw9Cf7zZBlCLoVM6uLil8PwiouzC5xk+/9mnaWw3MGS0slYLzYKstSqXOCsd2nUa3pixYqiSKVi6QJWttpHbM46W/05abSWTL3wsp3O1Oa2sELJCpX1fxzRItEyuD+eQskKaGTo+7ybpJL3wrlQb2S7L08=
Message-ID: <46AF9D54.6060807@googlemail.com>
Date: Tue, 31 Jul 2007 22:36:36 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Netdev" <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Get rid of dead code in net/wanrouter/wanmain.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File /home/devel/linux-rdc/net/wanrouter/wanmain.c line 569
Unknown CONFIG option! CONFIG_WANPIPE_MULTPPP
File /home/devel/linux-rdc/net/wanrouter/wanmain.c line 590
Unknown CONFIG option! CONFIG_WANPIPE_MULTPPP
File /home/devel/linux-rdc/net/wanrouter/wanmain.c line 663
Unknown CONFIG option! CONFIG_WANPIPE_MULTPPP

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-rdc-clean/net/wanrouter/wanmain.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-rdc/net/wanrouter/wanmain.c	2007-07-31 18:04:58.000000000 +0200
@@ -566,9 +566,6 @@ static int wanrouter_device_new_if(struc
 {
 	wanif_conf_t *cnf;
 	struct net_device *dev = NULL;
-#ifdef CONFIG_WANPIPE_MULTPPP
-	struct ppp_device *pppdev=NULL;
-#endif
 	int err;
 
 	if ((wandev->state == WAN_UNCONFIGURED) || (wandev->new_if == NULL))
@@ -587,25 +584,10 @@ static int wanrouter_device_new_if(struc
 		goto out;
 
 	if (cnf->config_id == WANCONFIG_MPPP) {
-#ifdef CONFIG_WANPIPE_MULTPPP
-		pppdev = kzalloc(sizeof(struct ppp_device), GFP_KERNEL);
-		err = -ENOBUFS;
-		if (pppdev == NULL)
-			goto out;
-		pppdev->dev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
-		if (pppdev->dev == NULL) {
-			kfree(pppdev);
-			err = -ENOBUFS;
-			goto out;
-		}
-		err = wandev->new_if(wandev, (struct net_device *)pppdev, cnf);
-		dev = pppdev->dev;
-#else
 		printk(KERN_INFO "%s: Wanpipe Mulit-Port PPP support has not been compiled in!\n",
 				wandev->name);
 		err = -EPROTONOSUPPORT;
 		goto out;
-#endif
 	} else {
 		dev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
 		err = -ENOBUFS;
@@ -660,16 +642,9 @@ static int wanrouter_device_new_if(struc
 	kfree(dev->priv);
 	dev->priv = NULL;
 
-#ifdef CONFIG_WANPIPE_MULTPPP
-	if (cnf->config_id == WANCONFIG_MPPP)
-		kfree(pppdev);
-	else
-		kfree(dev);
-#else
 	/* Sync PPP is disabled */
 	if (cnf->config_id != WANCONFIG_MPPP)
 		kfree(dev);
-#endif
 
 out:
 	kfree(cnf);
