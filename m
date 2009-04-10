Return-Path: <linux-kernel-owner+w=401wt.eu-S937061AbZDJNNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937061AbZDJNNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZDJNNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:13:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:16922 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbZDJNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=vJze3l9zYuePN+oEWCSN4bCgei4Qm6Api4hVqs1TDXuXucA9I/KMia3iTHjUlOJ4Ft
         kdpdqmUNn2eTzBGnbRGc5oJOI9dSDYQnSLeOh83uCbpdAPbkYAqca7ZzcUPuIgBUqNsX
         F0PLt2Uq/5MoqoWSsZAI+SaQDSWu4vvCbKUlE=
Date: Fri, 10 Apr 2009 21:11:57 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org
Subject: [PATCH]fix a warning on drivers/net/via-velocity.c
Message-ID: <20090410131157.GA10063@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this waring:

drivers/net/via-velocity.c: In function ‘velocity_open’:
drivers/net/via-velocity.c:1924: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type


>From daa9a8764a7a4261597a6b75230b9029d7723336 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Fri, 10 Apr 2009 21:06:39 +0800
Subject: [PATCH] fix a warning on drivers/net/via-velocity.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/net/via-velocity.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index fb53ef8..754a4b1 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -377,7 +377,7 @@ static void velocity_print_info(struct velocity_info *vptr);
 static int velocity_open(struct net_device *dev);
 static int velocity_change_mtu(struct net_device *dev, int mtu);
 static int velocity_xmit(struct sk_buff *skb, struct net_device *dev);
-static int velocity_intr(int irq, void *dev_instance);
+static irqreturn_t velocity_intr(int irq, void *dev_instance);
 static void velocity_set_multi(struct net_device *dev);
 static struct net_device_stats *velocity_get_stats(struct net_device *dev);
 static int velocity_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
@@ -2215,7 +2215,7 @@ out:
  *	efficiently as possible.
  */
 
-static int velocity_intr(int irq, void *dev_instance)
+static irqreturn_t velocity_intr(int irq, void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
 	struct velocity_info *vptr = netdev_priv(dev);
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
