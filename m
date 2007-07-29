Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXG2PHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXG2PHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764381AbXG2O7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47833 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764482AbXG2O7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:03 -0400
Date: Sun, 29 Jul 2007 16:58:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jamal Hadi Salim <hadi@cyberus.ca>,
       Robert Olsson <robert.olsson@its.uu.se>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] make pktgen.c:get_ipsec_sa() static and non-inline
Message-ID: <20070729145840.GY16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Non-static inline code usually doesn't makes sense.

In this case making is static and non-inline is the correct solution.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/net/core/pktgen.c.old	2007-07-26 20:12:01.000000000 +0200
+++ linux-2.6.23-rc1-mm1/net/core/pktgen.c	2007-07-26 20:12:13.000000000 +0200
@@ -2156,8 +2156,7 @@
 /* If there was already an IPSEC SA, we keep it as is, else
  * we go look for it ...
 */
-inline
-void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
+static void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
 {
 	struct xfrm_state *x = pkt_dev->flows[flow].x;
 	if (!x) {

