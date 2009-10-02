Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZJBMk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZJBMk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZJBMkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:40:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:53870 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbZJBMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:40:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>
Cc: dm-devel@redhat.com, Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 8/8] uvesafb/connector: Disallow unpliviged users to send netlink packets
Date: Fri,  2 Oct 2009 14:40:11 +0200
Message-Id: <1254487211-11810-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1254487211-11810-8-git-send-email-philipp.reisner@linbit.com>
References: <1254487211-11810-1-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-2-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-3-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-4-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-5-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-6-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-7-git-send-email-philipp.reisner@linbit.com>
 <1254487211-11810-8-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/video/uvesafb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index aa7cd95..e35232a 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -72,6 +72,9 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
+		return;
+
 	if (msg->seq >= UVESAFB_TASKS_MAX)
 		return;
 
-- 
1.6.0.4

