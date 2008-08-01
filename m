Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYHAMSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYHAMSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYHAMSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:18:08 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:37262 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbYHAMSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:18:06 -0400
Subject: [PATCH] sched: reorder signal_struct to remove 8 bytes on 64 bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:18:04 +0100
Message-Id: <1217593084.2953.13.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder structure to remove 8 bytes of padding on 64 bit builds

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.27-rc1
compiled & tested on AMD64 desktop

Richard

 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3f18cd2..12b708f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -450,8 +450,8 @@ struct signal_struct {
 	 * - everyone except group_exit_task is stopped during signal delivery
 	 *   of fatal signals, group_exit_task processes the signal.
 	 */
-	struct task_struct	*group_exit_task;
 	int			notify_count;
+	struct task_struct	*group_exit_task;
 
 	/* thread group stop support, overloads group_exit_code too */
 	int			group_stop_count;
-- 
1.5.5.1



