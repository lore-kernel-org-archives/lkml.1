Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYBLXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYBLXJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYBLXJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:09:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbYBLXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=cwmLJboP+weJvwr5sunkOvSu8p2DeP/xLZUNg3/mTUooANLbmZgzbTE/waWIwyHZkv6NSB+roGCgGgaexs06bUSlu18YTOn8JHrJvfS0IC4VdmPoMI5EV0TDsA93oLaEqcTzmigsl2d5SIePH/JeQWhmvhfU2vCwBYUIgyDF8YU=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: [PATCH] ipw2200: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:12 +0100
Message-Id: <1202857582-15450-8-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ipw2200.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 3e6ad7b..5d9854e 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10326,9 +10326,7 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 					 remaining_bytes,
 					 PCI_DMA_TODEVICE));
 
-			tfd->u.data.num_chunks =
-			    cpu_to_le32(le32_to_cpu(tfd->u.data.num_chunks) +
-					1);
+			le32_add_cpu(&tfd->u.data.num_chunks, 1);
 		}
 	}
 
-- 
1.5.3.7

