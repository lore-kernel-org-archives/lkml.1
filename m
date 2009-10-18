Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZJRWZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZJRWZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZJRWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:25:46 -0400
Received: from smtp104.biz.mail.mud.yahoo.com ([68.142.200.252]:28962 "HELO
	smtp104.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752196AbZJRWZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:25:46 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: 0mv8j1UVM1kI.0R7AqSVcci121_Z6jafDvmu6iqlqBkpMY0Zfc0Lc7EMf8DId4qUA9czfdWDG3X3DeG0vvqM_SbLS.q2BCwbJCVfRXsZ9VzTviUAS5qCkGGYcBmYUPDVDwfadXDvd38xI2rFEmdZcV0lKHOStKe5jeyo8aSQLU_bVxrkssbICvs08.IGOXjftFm_J9d4H_Wkr3uVWD.5KpEoEVGJ4gC4UC0dUhIi3QBAd8MV6mrfQTNMyG_i_Dj9ylNb7.PBt4pHOfeuRNU64TiplH5lZfclaWFXIIflcF9EIUF7Qy6NxFJCsoGKaYi8Op5PhWwt0oocaQ2x7_jDg6R5Y11BT6Mv.0eRKToNDvr3XuaL5vddEikGaP2UNZ4ZflTgQPyK0Dtj9OulfIooxA--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix section mismatch in fec.c
Date: Sun, 18 Oct 2009 15:25:48 -0700
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910181525.48574.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fec_enet_init is called by both fec_probe and fec_resume, so it shouldn't 
be marked as __init.

Signed-off-by: Steven King <sfking@fdwdc.com>


diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 2923438..e8218a3 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -1654,7 +1654,8 @@ static const struct net_device_ops fec_netdev_ops = {
   *
   * index is only used in legacy code
   */
-int __init fec_enet_init(struct net_device *dev, int index)
+static int
+fec_enet_init(struct net_device *dev, int index)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct bufdesc *cbd_base;

-- 
Steven King -- sfking at fdwdc dot com
