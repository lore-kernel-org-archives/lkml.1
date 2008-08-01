Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYHAMgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYHAMgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYHAMgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:36:40 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:2345 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbYHAMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:36:40 -0400
Subject: [PATCH] reorder struct prop_local_single to remove padding on 64
	bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: peterz@infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:36:28 +0100
Message-Id: <1217594188.2953.24.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder structure to remove 8 bytes of padding on 64 bit builds

(also removes 8 bytes from task_struct)

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.27-rc1
compiled & tested on AMD64 desktop

Richard


 include/linux/proportions.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index 5afc1b2..cf793bb 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -104,8 +104,8 @@ struct prop_local_single {
 	 * snapshot of the last seen global state
 	 * and a lock protecting this state
 	 */
-	int shift;
 	unsigned long period;
+	int shift;
 	spinlock_t lock;		/* protect the snapshot state */
 };
 
-- 
1.5.5.1



