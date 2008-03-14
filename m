Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYCNVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYCNVXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYCNVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:23:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:22000 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYCNVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CTZJ/FNkRbhIxvRohtF6Fv5fq7TJHKDbApNGrg6IzL0RNfKf6V9E/kuGVPrQmRrjWKsB1ccBMUDderma/Ic7c9STDy/JNMmMo4zOkgB7ofS+WFllY1/iNMm/R4D/+icYN0QNTctG1oZEN7G6EmAa4N3C3bFqPaKYb6eCqNnYvgA=
Subject: Re: Updated generic semaphore patch set
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu
In-Reply-To: <20080314204248.GV613@parisc-linux.org>
References: <20080314204248.GV613@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 14:23:33 -0700
Message-Id: <1205529813.27712.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] semaphore: add stubs for kerneldoc to semphore functions

The difference between down/down_trylock/down_interruptable/down_killable
should be expanded to note the difference/use case, a simple stub is added here.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This applies on top of the last patch I sent, feel free to just use it as
a base for a fuller version.

 kernel/semaphore.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index bae1017..f48ac5e 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -98,6 +98,12 @@ static noinline void __sched __up(struct semaphore *sem)
 	wake_up_process(waiter->task);
 }
 
+/**
+ * down - acquire the semaphore
+ * @sem: the semaphore to be acquired
+ *
+ * This can be called from interrupt context, unlike mutexes.
+ */
 void down(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -111,6 +117,12 @@ void down(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down);
 
+/**
+ * down_killable - try to acquire the semaphore
+ * @sem: the semaphore to be acquired
+ *
+ * This can be called from interrupt context, unlike mutexes.
+ */
 int down_interruptible(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -127,6 +139,12 @@ int down_interruptible(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_interruptible);
 
+/**
+ * down_killable - try to acquire the semaphore
+ * @sem: the semaphore to be acquired
+ *
+ * This can be called from interrupt context, unlike mutexes.
+ */
 int down_killable(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -147,7 +165,7 @@ EXPORT_SYMBOL(down_killable);
  * down_trylock - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
  *
- * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
+ * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
  * been acquired successfully and 1 if it is contended.
  *
  * NOTE: This return value is inverted from both spin_trylock and
@@ -171,7 +189,14 @@ int down_trylock(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_trylock);
 
-int down_timeout(struct semaphore *sem, long jiffies)
+/**
+ * down_timeout - try to acquire the semaphore within a timeout
+ * @sem: the semaphore to be acquired
+ * @timeout: the length to wait before timing out, in jiffies
+ *
+ * This can be called from interrupt context, unlike mutexes.
+ */
+int down_timeout(struct semaphore *sem, long timeout)
 {
 	unsigned long flags;
 	int result = 0;
@@ -180,13 +205,19 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	if (likely(sem->count > 0))
 		sem->count--;
 	else
-		result = __down_timeout(sem, jiffies);
+		result = __down_timeout(sem, timeout);
 	spin_unlock_irqrestore(&sem->lock, flags);
 
 	return result;
 }
 EXPORT_SYMBOL(down_timeout);
 
+/**
+ * up - release the semaphore
+ * @sem: the semaphore to be released
+ *
+ * This can be called from interrupt context, unlike mutexes.
+ */
 void up(struct semaphore *sem)
 {
 	unsigned long flags;
-- 
1.5.4.4.684.g0e08



