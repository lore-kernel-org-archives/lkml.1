Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZJTXAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZJTXAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZJTXAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:00:10 -0400
Received: from smtp104.biz.mail.mud.yahoo.com ([68.142.200.252]:23981 "HELO
	smtp104.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752388AbZJTXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:00:09 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: NE4FQeUVM1kwlfWgZ0SLeCZaBjd9FzruJ_5jErqrMgac8WCCwM5neu9_bWPPUl9mC7CPB9XxTM9wGMJkXn.WZcG_UInFTlvPaVsXSCFQfpteNQNQdE05.MSBRGoLdX3XuX6Vsd_juwtHrVF42H7tWSRwFHNbfDykJ.JKxssfsjlIZ7pCCuzmEJn3MOQTbirz7ausEOnDAre.WG27Xh3fvaUJEqeGWjFyO4_zTjUWhlykrbAJwlRH61CBH2Ce0oy5HOrQP2TshCCZlP_.x.7iOm7opJFOL5vfHGJXXtSRGZDg.GRRSdnaa6mljny8bqUGBLCvTV6snL9tspHWWGrJ._luWcxrtFi_nzzJcMpK0Z2MqVIKd4Ergf4MUoV_yZo3a8_Rs4Pbv1193nqmiGOJ80NOMtK0NmI3WUxIis4-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] fix section mismatch in fec.c
Date: Tue, 20 Oct 2009 16:00:10 -0700
User-Agent: KMail/1.9.9
Organization: fdwdc.com
Cc: netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910201600.10545.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fec_enet_init is called by both fec_probe and fec_resume, so it shouldn't 
be marked as __init.

Signed-off-by: Steven King <sfking@fdwdc.com>


diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 2923438..16a1d58 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -1654,7 +1654,7 @@ static const struct net_device_ops fec_netdev_ops = {
   *
   * index is only used in legacy code
   */
-int __init fec_enet_init(struct net_device *dev, int index)
+static int fec_enet_init(struct net_device *dev, int index)
 {
 	struct fec_enet_private *fep = netdev_priv(dev);
 	struct bufdesc *cbd_base;

-- 
Steven King -- sfking at fdwdc dot com
