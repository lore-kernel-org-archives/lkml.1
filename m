Return-Path: <linux-kernel-owner+w=401wt.eu-S966419AbXEHK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966419AbXEHK1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934701AbXEHK1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:27:31 -0400
Received: from mx12.go2.pl ([193.17.41.142]:60594 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934643AbXEHK1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:27:31 -0400
Date: Tue, 8 May 2007 12:33:48 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH -mm] timer: parenthesis fix in tbase_get_deferrable() etc.
Message-ID: <20070508103348.GC1772@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-mm1-/kernel/timer.c 2.6.21-mm1/kernel/timer.c
--- 2.6.21-mm1-/kernel/timer.c	2007-05-08 11:54:48.000000000 +0200
+++ 2.6.21-mm1/kernel/timer.c	2007-05-08 12:05:11.000000000 +0200
@@ -92,24 +92,24 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
 /* Functions below help us manage 'deferrable' flag */
 static inline unsigned int tbase_get_deferrable(tvec_base_t *base)
 {
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
+	return (unsigned int)((unsigned long)base & TBASE_DEFERRABLE_FLAG);
 }
 
 static inline tvec_base_t *tbase_get_base(tvec_base_t *base)
 {
-	return ((tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
+	return (tvec_base_t *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG);
 }
 
 static inline void timer_set_deferrable(struct timer_list *timer)
 {
-	timer->base = ((tvec_base_t *)((unsigned long)(timer->base) |
-	                               TBASE_DEFERRABLE_FLAG));
+	timer->base = (tvec_base_t *)((unsigned long)timer->base |
+	                               TBASE_DEFERRABLE_FLAG);
 }
 
 static inline void
 timer_set_base(struct timer_list *timer, tvec_base_t *new_base)
 {
-	timer->base = (tvec_base_t *)((unsigned long)(new_base) |
+	timer->base = (tvec_base_t *)((unsigned long)new_base |
 	                              tbase_get_deferrable(timer->base));
 }
 
