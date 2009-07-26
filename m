Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZGZIVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZGZIVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZGZIVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:20 -0400
Received: from www.tglx.de ([62.245.132.106]:33905 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZGZIVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:05 -0400
Message-Id: <20090726081557.120760694@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [Patch RFC 29/37] infiniband: Make user_mad semaphore a real one
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-infiniband-core-user-mad-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/core/user_mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/infiniband/core/user_mad.c
===================================================================
--- linux-2.6-tip.orig/drivers/infiniband/core/user_mad.c
+++ linux-2.6-tip/drivers/infiniband/core/user_mad.c
@@ -1003,7 +1003,7 @@ static int ib_umad_init_port(struct ib_d
 
 	port->ib_dev   = device;
 	port->port_num = port_num;
-	init_MUTEX(&port->sm_sem);
+	semaphore_init(&port->sm_sem);
 	mutex_init(&port->file_mutex);
 	INIT_LIST_HEAD(&port->file_list);
 


