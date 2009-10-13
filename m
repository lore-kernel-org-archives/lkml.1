Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbZJMJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbZJMJ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933314AbZJMJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:29:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52364 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZJMJ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:29:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 5/7] dst/connector: Disallow unpliviged users to configure dst
Date: Tue, 13 Oct 2009 11:28:16 +0200
Message-Id: <1255426098-9411-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255426098-9411-5-git-send-email-philipp.reisner@linbit.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-3-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-4-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-5-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
(cherry picked from commit dbbb3431228784612848a1ec6061c78b4b708b5c)
---
 drivers/staging/dst/dcore.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index 32f102d..5546898 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -854,6 +854,11 @@ static void cn_dst_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	struct dst_node *n = NULL, *tmp;
 	unsigned int hash;
 
+	if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out;
+	}
+
 	if (msg->len < sizeof(struct dst_ctl)) {
 		err = -EBADMSG;
 		goto out;
-- 
1.6.0.4

