Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYHSCGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYHSCGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYHSCGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:06:33 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:51862 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYHSCGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:06:32 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 22:06:32 EDT
Message-ID: <48AA27AF.9070407@hypersurf.com>
Date: Mon, 18 Aug 2008 18:53:51 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: Corrections please ...]
Content-Type: multipart/mixed;
 boundary="------------030906080302060606030405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030906080302060606030405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Could someone ... anyone take a look at these kernel doc additions?

Thanks!

kevin

--------------030906080302060606030405
Content-Type: message/rfc822;
 name="Corrections please ..."
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Corrections please ..."

Message-ID: <48A9E2C6.1030205@hypersurf.com>
Date: Mon, 18 Aug 2008 13:59:50 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
Subject: Corrections please ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Could I get any needed corrections on this. Especially on the "???"

[kevdig@PowerMac8600B linux-2.6.26]$ diff -U3 
include/linux/completion.{h.orig,h}|more
--- include/linux/completion.h.orig     2008-08-13 00:56:52.000000000 -0700
+++ include/linux/completion.h  2008-08-18 13:00:23.000000000 -0700
@@ -10,6 +10,16 @@

  #include <linux/wait.h>

+/**
+ * struct completion - structure used to maintain state for a "completion"
+ * @done:  counting variable used to signal completion
+ * @wait:  internal wait queue head; used for locking and synchronization
+ *
+ * This is the structure used to maintain the state for a "completion". See
+ * also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), 
init_completion(),
+ * and macros DECLARE_COMPLETION() and INIT_COMPLETION().
+ */
  struct completion {
         unsigned int done;
         wait_queue_head_t wait;
@@ -36,6 +46,13 @@
  # define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
  #endif

+/**
+ * init_completion: - Initialize a dynamically allocated completion
+ * @x:  completion structure that is to be initialized
+ *
+ * This inline function will initialize a dynamically created completion
+ * structure.
+ */
  static inline void init_completion(struct completion *x)
  {
         x->done = 0;


--- kernel/sched.c.orig 2008-08-13 02:22:42.000000000 -0700
+++ kernel/sched.c      2008-08-18 13:31:03.000000000 -0700
@@ -4363,6 +4363,13 @@
  }
  EXPORT_SYMBOL_GPL(__wake_up_sync);     /* For internal use only */

+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. If 
multiple
+ * threads are waiting ???
+ */
  void complete(struct completion *x)
  {
         unsigned long flags;
@@ -4374,6 +4381,12 @@
  }
  EXPORT_SYMBOL(complete);

+/**
+ * complete_all: - signals all threads waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up all threads waiting on this particular completion 
event.
+ */
  void complete_all(struct completion *x)
  {
         unsigned long flags;
@@ -4425,12 +4438,27 @@
         return timeout;
  }

+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
+ */
  void __sched wait_for_completion(struct completion *x)
  {
         wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
  }
  EXPORT_SYMBOL(wait_for_completion);

+/**
+ * wait_for_completion_timeout: - waits for completion of a task 
(w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible. But there is a timeout in jiffies.
+ */
  unsigned long __sched
  wait_for_completion_timeout(struct completion *x, unsigned long timeout)
  {
@@ -4438,6 +4466,13 @@
  }
  EXPORT_SYMBOL(wait_for_completion_timeout);

+/**
+ * wait_for_completion_interruptible: - waits for completion of a task 
(w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is
+ * interruptible.
+ */
  int __sched wait_for_completion_interruptible(struct completion *x)
  {
         long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, 
TASK_INTERRUPTIBLE);
@@ -4447,6 +4482,14 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible);

+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion 
(w/(to,int
r))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits to be signaled for completion of a specific task. It is
+ * interruptible. And there is a timeout in jiffies.
+ */
  unsigned long __sched
  wait_for_completion_interruptible_timeout(struct completion *x,
                                           unsigned long timeout)
@@ -4455,6 +4498,13 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);

+/**
+ * wait_for_completion_killable: - waits for completion of a task 
(killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is
+ * killable (???).
+ */
  int __sched wait_for_completion_killable(struct completion *x)
  {
         long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);


--------------030906080302060606030405--
