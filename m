Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372Ab0A1Xox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0A1Xox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096Ab0A1Xov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:44:51 -0500
Received: from ozlabs.org ([203.10.76.45]:37442 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab0A1Xov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:44:51 -0500
Date: Fri, 29 Jan 2010 10:41:25 +1100
From: Anton Blanchard <anton@samba.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-28-01-36 uploaded (sched.c + percpu)
Message-ID: <20100128234125.GH2996@kryten>
References: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
 <4B61DD8F.6020507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61DD8F.6020507@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Randy,

> when CONFIG_SMP is not enabled:
> 
> kernel/sched.c:10915: error: 'percpu_counter_batch' undeclared (first use in this function)

Did 1/2 make it into mmotm? 

Anton

---

[PATCH 1/2] percpu_counter: Make __percpu_counter_add an inline function on UP

Even though batch isn't used on UP, we may want to pass one in to keep the
SMP and UP code paths similar. Convert __percpu_counter_add to an inline
function so we wont get variable unused warnings if we do.
 
Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index a7684a5..794662b 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -98,9 +98,6 @@ static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	fbc->count = amount;
 }
 
-#define __percpu_counter_add(fbc, amount, batch) \
-	percpu_counter_add(fbc, amount)
-
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -109,6 +106,12 @@ percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 	preempt_enable();
 }
 
+static inline void
+__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
+{
+	percpu_counter_add(fbc, amount);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;

