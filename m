Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZJBMkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZJBMkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbZJBMkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:40:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:53831 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZJBMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:40:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>
Cc: dm-devel@redhat.com, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 7/8] pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
Date: Fri,  2 Oct 2009 14:40:10 +0200
Message-Id: <1254487211-11810-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1254487211-11810-7-git-send-email-philipp.reisner@linbit.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-2-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-3-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-4-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-5-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-6-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-7-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/staging/pohmelfs/config.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index c9162b3..5d04bf5 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -531,6 +531,9 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
 {
 	int err;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	switch (msg->flags) {
 		case POHMELFS_FLAGS_ADD:
 		case POHMELFS_FLAGS_DEL:
-- 
1.6.0.4

