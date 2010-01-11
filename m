Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326Ab0AKV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0AKV13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852Ab0AKV1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0AKV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ASR0iueVe+rcpfMMn3Y4M8M/0BoMqgqLX/vQQpZSi/mup6AApalIXwRue8Wg6uOwOF
         m89IUvmDm0qBVc7SBf6fbF1WvBWmc7E7nV/wT7hLaYOVsPrrVsu1fnG0J3cxO5ZA+Xu/
         SZj6/V162oV4atBw8dblSrG4z6f7msopLH7PU=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 11/26] rtmutex: Convert wait_lock and pi_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:41 +0100
Message-Id: <1263245216-14754-12-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-11-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks.
See d227cf76b6f51e3245f1b3f47720c3d7df4b68b0
missing from d209d74d52ab39dc071656533cac095294f70de7

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/rtmutex.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 281d8fd..ac76f7b 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -98,7 +98,7 @@ extern void rt_mutex_unlock(struct rt_mutex *lock);
 
 #ifdef CONFIG_RT_MUTEXES
 # define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters, tsk.pi_lock),	\
+	.pi_waiters	= PLIST_HEAD_INIT_RAW(tsk.pi_waiters, tsk.pi_lock),	\
 	INIT_RT_MUTEX_DEBUG(tsk)
 #else
 # define INIT_RT_MUTEXES(tsk)
-- 
1.6.5.2

