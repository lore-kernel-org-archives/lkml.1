Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYHAMY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYHAMY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYHAMYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:24:20 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:4530 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYHAMYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:24:19 -0400
Subject: [PATCH] sched: reorder struct sched_rt_entity to remove padding on
	64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:24:08 +0100
Message-Id: <1217593448.2953.16.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove 8 bytes of padding on 64 bit builds
(also removes 8 bytes from task_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.27-rc1
compiled & tested on AMD64 desktop

Richard

 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5270d44..3f18cd2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1009,8 +1009,8 @@ struct sched_entity {
 
 struct sched_rt_entity {
 	struct list_head run_list;
-	unsigned int time_slice;
 	unsigned long timeout;
+	unsigned int time_slice;
 	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
-- 
1.5.5.1



