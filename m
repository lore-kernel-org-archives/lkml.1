Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbZJMJ3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbZJMJ3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbZJMJ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:29:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52365 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226AbZJMJ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:29:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 6/7] pohmelfs/connector: Disallow unpliviged users to configure pohmelfs
Date: Tue, 13 Oct 2009 11:28:17 +0200
Message-Id: <1255426098-9411-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255426098-9411-6-git-send-email-philipp.reisner@linbit.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-3-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-4-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-5-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-6-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
(cherry picked from commit 0179065b13b354cc0b940e7a632a65ec0448beff)
---
 drivers/staging/pohmelfs/config.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index 1b4d564..d8ec47a 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -450,6 +450,9 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
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

