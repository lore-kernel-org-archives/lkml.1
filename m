Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYCVDlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYCVDlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYCVDlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:41:12 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2681 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYCVDlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:41:11 -0400
Date: Fri, 21 Mar 2008 21:41:05 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] [POWERPC] mpc5200: fix null dereference if bestcomm fails to
 initialize
In-reply-to: <>
To: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Message-id: <1206157265-6973-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.5.4.3
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bestcomm initialization fails, calls to the task allocate
function should fail gracefully instead of oopsing with a NULL deref.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Paul, here's another bug fix that I'd like picked up for .25

 arch/powerpc/sysdev/bestcomm/bestcomm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
index f589999..f9cd04e 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
@@ -52,6 +52,10 @@ bcom_task_alloc(int bd_count, int bd_size, int priv_size)
 	int i, tasknum = -1;
 	struct bcom_task *tsk;
 
+	/* Don't try to do anything is bestcomm init failed */
+	if (!bcom_eng)
+		return NULL;
+
 	/* Get and reserve a task num */
 	spin_lock(&bcom_eng->lock);
 
-- 
1.5.4.3

