Return-Path: <linux-kernel-owner+w=401wt.eu-S1767066AbXDTMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767066AbXDTMHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767070AbXDTMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:07:19 -0400
Received: from mx10.go2.pl ([193.17.41.74]:37815 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767066AbXDTMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:07:18 -0400
Date: Fri, 20 Apr 2007 14:12:56 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH] workqueue: cancel_rearming_delayed_work/workqueue usage warning
Message-ID: <20070420121255.GA4042@ff.dom.local>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com> <20070420081325.GB1695@ff.dom.local> <20070420085354.GP32602149@melbourne.sgi.com> <20070420102157.GD1695@ff.dom.local> <20070420110119.GS32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420110119.GS32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is my proposal to make things clearer:
(this time on 2.6.21-rc7)

CC: David Chinner <dgc@sgi.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.21-rc7-/kernel/workqueue.c 2.6.21-rc7/kernel/workqueue.c
--- 2.6.21-rc7-/kernel/workqueue.c	2007-04-18 10:14:16.000000000 +0200
+++ 2.6.21-rc7/kernel/workqueue.c	2007-04-20 13:56:51.000000000 +0200
@@ -662,6 +662,8 @@ EXPORT_SYMBOL(flush_scheduled_work);
  * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
  * @dwork: the delayed work struct
+ *
+ * WARNING: use only with handlers, which rearm unconditionally with delay > 0
  */
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
@@ -674,6 +676,8 @@ EXPORT_SYMBOL(cancel_rearming_delayed_wo
 /**
  * cancel_rearming_delayed_work - reliably kill off a delayed keventd work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
+ *
+ * WARNING: use only with handlers, which rearm unconditionally with delay > 0
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
 {
