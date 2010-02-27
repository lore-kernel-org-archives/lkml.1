Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966554Ab0B0WyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:54:16 -0500
Received: from ozlabs.org ([203.10.76.45]:37381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965848Ab0B0WyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:54:15 -0500
Date: Sun, 28 Feb 2010 09:52:34 +1100
From: Anton Blanchard <anton@samba.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: [PATCH] workqueue: Fix build on PowerPC
Message-ID: <20100227225234.GA13594@kryten>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following compile error on PowerPC:

include/linux/workqueue.h:66: error: ‘NR_CPUS’ undeclared here (not in a function)

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 66573b8..5d1d9be 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
+#include <linux/threads.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
