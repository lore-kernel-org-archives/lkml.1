Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZGZI0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZGZI0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZGZI0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:26:18 -0400
Received: from www.tglx.de ([62.245.132.106]:41598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZGZI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:26:16 -0400
Message-Id: <20090726081557.506974312@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [Patch RFC 32/37] drivers/macintosh/adb: Do not claim that the
	semaphore is a mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=drivers-macintosh-adb-sema-no-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and used as completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/macintosh/adb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/macintosh/adb.c
===================================================================
--- linux-2.6-tip.orig/drivers/macintosh/adb.c
+++ linux-2.6-tip/drivers/macintosh/adb.c
@@ -83,7 +83,7 @@ static struct adb_driver *adb_controller
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static DECLARE_MUTEX(adb_probe_mutex);
+static DEFINE_SEMAPHORE(adb_probe_mutex);
 static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;


