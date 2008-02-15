Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbYBOU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbYBOU7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbYBOU66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:58:58 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56091 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbYBOU65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:58:57 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 1/3] WDEV: ath5k, fix lock imbalance
Date: Fri, 15 Feb 2008 21:58:51 +0100
Message-Id: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omitted lock causes sparse warning
drivers/net/wireless/ath5k/base.c:1682:1: warning: context imbalance in 'ath5k_tasklet_rx' - different lock contexts for basic block

Add the lock to the guilty fail path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ddc8714..49d38e8 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1715,6 +1715,7 @@ ath5k_tasklet_rx(unsigned long data)
 			break;
 		else if (unlikely(ret)) {
 			ATH5K_ERR(sc, "error in processing rx descriptor\n");
+			spin_unlock(&sc->rxbuflock);
 			return;
 		}
 
-- 
1.5.3.8

