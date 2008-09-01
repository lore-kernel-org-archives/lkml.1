Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYIAXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYIAXTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYIAXQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:16:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIAXQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:16:14 -0400
Date: Mon, 1 Sep 2008 16:12:16 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 10/13] hrtimer: rename the "expires" struct member to avoid
 accidental usage
Message-ID: <20080901161216.50097cd8@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: rename the "expires" struct member to avoid accidental usage

To catch code that still touches the "expires" memory directly, rename it
to have the compiler complain rather than get nasty, hard to explain,
runtime behavior

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/hrtimer.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 9900e99..485a634 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -111,7 +111,7 @@ enum hrtimer_cb_mode {
  */
 struct hrtimer {
 	struct rb_node			node;
-	ktime_t				expires;
+	ktime_t				_expires;
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
@@ -219,41 +219,41 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 
 static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
 {
-	timer->expires = time;
+	timer->_expires = time;
 }
 static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
 {
-	timer->expires.tv64 = tv64;
+	timer->_expires.tv64 = tv64;
 }
 
 static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
 {
-	timer->expires = ktime_add_safe(timer->expires, time);
+	timer->_expires = ktime_add_safe(timer->_expires, time);
 }
 
 static inline void hrtimer_add_expires_ns(struct hrtimer *timer, unsigned long ns)
 {
-	timer->expires = ktime_add_ns(timer->expires, ns);
+	timer->_expires = ktime_add_ns(timer->_expires, ns);
 }
 
 static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
 {
-	return timer->expires;
+	return timer->_expires;
 }
 
 static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
 {
-	return timer->expires.tv64;
+	return timer->_expires.tv64;
 }
 
 static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
 {
-	return ktime_to_ns(timer->expires);
+	return ktime_to_ns(timer->_expires);
 }
 
 static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 {
-    return ktime_sub(timer->expires, timer->base->get_time());
+    return ktime_sub(timer->_expires, timer->base->get_time());
 }
 
 /*
@@ -334,7 +334,7 @@ static inline int hrtimer_start_expires(struct hrtimer *timer,
 
 static inline int hrtimer_restart(struct hrtimer *timer)
 {
-	return hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+	return hrtimer_start(timer, timer->_expires, HRTIMER_MODE_ABS);
 }
 
 /* Query timers: */
-- 
1.5.5.1

