Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbYDXPXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbYDXPXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYDXPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:15:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44183
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758205AbYDXPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:15:11 -0400
Date: Thu, 24 Apr 2008 08:15:10 -0700 (PDT)
Message-Id: <20080424.081510.141247541.davem@davemloft.net>
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: Third sched.git regression...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The fun just doesn't end.  Every machine I try the current tree on
fails in some new spectacular way due to the sched.git merge earlier
this week.

kernel/sched.c now does an alloc_bootmem_low() call

How, pray tell, is that supposed to work on systems that have no ram
below 4GB?

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/sched.c b/kernel/sched.c
index 0014b03..09ca69b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8128,7 +8128,7 @@ void __init sched_init(void)
 	 * we use alloc_bootmem().
 	 */
 	if (alloc_size) {
-		ptr = (unsigned long)alloc_bootmem_low(alloc_size);
+		ptr = (unsigned long)alloc_bootmem(alloc_size);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
