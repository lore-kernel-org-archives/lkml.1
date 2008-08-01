Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbYHAVZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbYHAVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762421AbYHAVRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:17:15 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:46126 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761468AbYHAVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:17:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC 5/7] rtmutex: use runtime init for rtmutexes
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rosted@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
Date: Fri, 01 Aug 2008 15:17:12 -0600
Message-ID: <20080801211712.3469.25099.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com>
References: <20080801210945.3469.1183.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
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

