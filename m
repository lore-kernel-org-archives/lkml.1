Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYFLEqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYFLEqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYFLEqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:46:40 -0400
Received: from baikonur.stro.at ([213.239.196.228]:47545 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYFLEqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:46:40 -0400
From: maximilian attems <max@stro.at>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>
Subject: [PATCH] [BLOCK] request_module() use format string
Date: Thu, 12 Jun 2008 06:46:33 +0200
Message-Id: <1213245993-9563-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

similar to 326f6a5c9c9e1a62aec37bdc0c3f8d53adabe77b,
but protected with safte checks.
anyway seems cleaner and easier to exclude.

Signed-off-by: maximilian attems <max@stro.at>
---
 block/elevator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 902dd13..a00eb38 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -144,7 +144,7 @@ static struct elevator_type *elevator_get(const char *name)
 		else
 			sprintf(elv, "%s-iosched", name);
 
-		request_module(elv);
+		request_module("%s", elv);
 		spin_lock(&elv_list_lock);
 		e = elevator_find(name);
 	}
-- 
1.5.5.1

