Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378Ab0AEAfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0AEAfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317Ab0AEAfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:16 -0500
Received: from kroah.org ([198.145.64.141]:34266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab0AEAfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/97] iwmc3200wifi: fix array out-of-boundary access
Date: Mon,  4 Jan 2010 16:32:53 -0800
Message-Id: <1262651630-7354-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhu Yi <yi.zhu@intel.com>

commit 6c853da3f30c93eae847ecbcd9fdf10ba0da04c2 upstream.

Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 1b02a4e..93c8989 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -258,7 +258,7 @@ struct iwm_priv {
 
 	struct sk_buff_head rx_list;
 	struct list_head rx_tickets;
-	struct list_head rx_packets[IWM_RX_ID_HASH];
+	struct list_head rx_packets[IWM_RX_ID_HASH + 1];
 	struct workqueue_struct *rx_wq;
 	struct work_struct rx_worker;
 
-- 
1.6.6

