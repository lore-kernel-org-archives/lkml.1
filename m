Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZIFIlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZIFIlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 04:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZIFIlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 04:41:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41766
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbZIFIlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 04:41:16 -0400
Date: Sun, 06 Sep 2009 01:41:31 -0700 (PDT)
Message-Id: <20090906.014131.78926800.davem@davemloft.net>
To: mike@it-loops.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       uchiyama.toru@jp.fujitsu.com
Subject: Re: 2.6.31-rc9 breaks gianfar
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090906072707.GA5699@trillian.comsick.at>
References: <20090906072707.GA5699@trillian.comsick.at>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Guntsche <mike@it-loops.com>
Date: Sun, 6 Sep 2009 09:27:08 +0200

Please also report networking bugs to netdev@vger.kernel.org
and CC: the person who commited the problematic commit.

> Commit 
> 38bddf04bcfe661fbdab94888c3b72c32f6873b3 gianfar: gfar_remove needs to call unregister_netdev()
> 
> breaks the build of the gianfar driver because "dev" is undefined in
> this function. To quickly test rc9 I changed this to priv->ndev but I do
> not know if this is the correct one.

Toru-chan, did you even compile test this again current kernels?

I'll commit the following fix and push it to Linus, thanks.

>From 5db8bfee2dbb3ff28c18868081398fa6e2155053 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Sun, 6 Sep 2009 01:41:02 -0700
Subject: [PATCH] gianfar: Fix build.

Reported by Michael Guntsche <mike@it-loops.com>

--------------------
Commit
38bddf04bcfe661fbdab94888c3b72c32f6873b3 gianfar: gfar_remove needs to call unregister_netdev()

breaks the build of the gianfar driver because "dev" is undefined in
this function. To quickly test rc9 I changed this to priv->ndev but I do
not know if this is the correct one.
--------------------

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/gianfar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 24f7ca5..a00ec63 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -491,7 +491,7 @@ static int gfar_remove(struct of_device *ofdev)
 
 	dev_set_drvdata(&ofdev->dev, NULL);
 
-	unregister_netdev(dev);
+	unregister_netdev(priv->ndev);
 	iounmap(priv->regs);
 	free_netdev(priv->ndev);
 
-- 
1.6.4.2

