Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYLVTT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYLVTT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYLVTQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:16:12 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:19066 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbYLVTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:16:09 -0500
Subject: [PATCH 08/27] drivers/net/cxgb3: comment out dead code
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:16:03 +0100
Message-ID: <20081222191603.11807.61006.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function 'vsc8211_set_speed_duplex' is not used, so comment it
out.  For 'vsc8211_set_automdi' the function 'vsc8211_set_speed_duplex'
is the only caller, so comment it out as well.

Fix this (sparse) warning:

  drivers/net/cxgb3/vsc8211.c:269: warning: 'vsc8211_set_automdi' defined but not used
  drivers/net/cxgb3/vsc8211.c:295:5: warning: symbol 'vsc8211_set_speed_duplex' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/cxgb3/vsc8211.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/vsc8211.c b/drivers/net/cxgb3/vsc8211.c
index 33f956b..d071309 100644
--- a/drivers/net/cxgb3/vsc8211.c
+++ b/drivers/net/cxgb3/vsc8211.c
@@ -262,6 +262,7 @@ static int vsc8211_get_link_status_fiber(struct cphy *cphy, int *link_ok,
 	return 0;
 }
 
+#ifdef UNUSED
 /*
  * Enable/disable auto MDI/MDI-X in forced link speed mode.
  */
@@ -301,6 +302,7 @@ int vsc8211_set_speed_duplex(struct cphy *phy, int speed, int duplex)
 		err = vsc8211_set_automdi(phy, 1);
 	return err;
 }
+#endif /* UNUSED */
 
 static int vsc8211_power_down(struct cphy *cphy, int enable)
 {

