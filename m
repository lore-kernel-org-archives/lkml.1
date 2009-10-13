Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZJMJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZJMJ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbZJMJ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:29:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52366 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbZJMJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:29:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 7/7] uvesafb/connector: Disallow unpliviged users to send netlink packets
Date: Tue, 13 Oct 2009 11:28:18 +0200
Message-Id: <1255426098-9411-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255426098-9411-7-git-send-email-philipp.reisner@linbit.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-3-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-4-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-5-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-6-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-7-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
(cherry picked from commit 30efa3f76813b17445bc5a2e443ae9731518566b)
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

