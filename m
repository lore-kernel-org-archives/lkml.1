Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZCXJAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZCXJAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZCXI7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:59:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38745 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZCXI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:59:46 -0400
Subject: [PATCH -tip] mutex: fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Mar 2009 14:29:21 +0530
Message-Id: <1237885161.5477.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Tue, 24 Mar 2009 14:21:57 +0530
Subject: [PATCH] mutex: fix compilation warning

  CC      kernel/mutex.o
include/linux/mutex.h:136: warning: ‘mutex_lock’ declared inline after being called
include/linux/mutex.h:136: warning: previous declaration of ‘mutex_lock’ was here

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/mutex.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 93054fc..c8c384c 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -133,7 +133,7 @@ extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
 #else
-extern void mutex_lock(struct mutex *lock);
+extern inline void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
 extern int __must_check mutex_lock_killable(struct mutex *lock);
 
-- 
1.6.0.6



