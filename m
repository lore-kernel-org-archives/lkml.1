Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXIZAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXIZAyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXIZAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:54:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46701 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbXIZAyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:54:15 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] put_user() on struct is not nice
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Message-Id: <E1IaLAA-000853-8q@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:54:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


use copy_to_user() instead...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/lguest/hypercalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index db6caac..5ecd60b 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -295,6 +295,6 @@ void write_timestamp(struct lguest *lg)
 {
 	struct timespec now;
 	ktime_get_real_ts(&now);
-	if (put_user(now, &lg->lguest_data->time))
+	if (copy_to_user(&lg->lguest_data->time, &now, sizeof(struct timespec)))
 		kill_guest(lg, "Writing timestamp");
 }
-- 
1.5.3.GIT


