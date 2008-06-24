Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYFXFz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYFXFz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYFXFzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:55:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYFXFzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:55:20 -0400
Date: Tue, 24 Jun 2008 01:55:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [1/10 PATCH] inline __queue_work
In-Reply-To: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make __queue_work inlined. It just takes spinlock and calls another function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/kernel/workqueue.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/workqueue.c	2008-06-24 07:28:15.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/workqueue.c	2008-06-24 07:37:08.000000000 +0200
@@ -141,8 +141,8 @@
  }

  /* Preempt must be disabled. */
-static void __queue_work(struct cpu_workqueue_struct *cwq,
-			 struct work_struct *work)
+static __always_inline void __queue_work(struct cpu_workqueue_struct *cwq,
+					 struct work_struct *work)
  {
  	unsigned long flags;


