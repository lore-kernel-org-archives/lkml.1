Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbYHOUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbYHOUcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761372AbYHOUbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:31:09 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36040
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761356AbYHOUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:31:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v4 6/8] rtmutex: use runtime init for rtmutexes
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com, jkacur@gmail.com
Date: Fri, 15 Aug 2008 16:28:50 -0400
Message-ID: <20080815202849.668.25293.stgit@dev.haskins.net>
In-Reply-To: <20080815202408.668.23736.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system already has facilities to perform late/run-time init for
rtmutexes.  We want to add more advanced initialization later in the
series so we force all rtmutexes through the init path in preparation
for the later patches.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/rtmutex.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index b263bac..14774ce 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -64,8 +64,6 @@ struct hrtimer_sleeper;
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = RAW_SPIN_LOCK_UNLOCKED(mutexname) \
-	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list, &mutexname.wait_lock) \
-	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
 #define DEFINE_RT_MUTEX(mutexname) \

