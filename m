Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbYCDQh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbYCDQh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765492AbYCDQbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:31:00 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48617 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765486AbYCDQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:58 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 03/11] memstick: make sure number of command retries is exactly as specified
Date: Wed,  5 Mar 2008 03:02:20 +1100
Message-Id: <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 3c97bac..decd6a4 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -236,7 +236,7 @@ int memstick_next_req(struct memstick_host *host, struct memstick_request **mrq)
 		rc = host->card->next_request(host->card, mrq);
 
 	if (!rc)
-		host->retries = cmd_retries;
+		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
 	else
 		*mrq = NULL;
 
-- 
1.5.3.6

