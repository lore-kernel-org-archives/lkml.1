Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0BDVua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:50:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46090 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab0BDVu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:50:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Net / pktgen: Fix freezing problem
Date: Thu, 4 Feb 2010 22:50:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: NetDev <netdev@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Ciprian Dorin Craciun <ciprian.craciun@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002042250.58944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Net / pktgen: Fix freezing problem

Add missing try_to_freeze() to one of the pktgen_thread_worker() code
paths so that it doesn't block suspend/hibernation.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=15006

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Ciprian Dorin Craciun <ciprian.craciun@gmail.com>
---
 net/core/pktgen.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/net/core/pktgen.c
===================================================================
--- linux-2.6.orig/net/core/pktgen.c
+++ linux-2.6/net/core/pktgen.c
@@ -3524,6 +3524,7 @@ static int pktgen_thread_worker(void *ar
 			wait_event_interruptible_timeout(t->queue,
 							 t->control != 0,
 							 HZ/10);
+			try_to_freeze();
 			continue;
 		}
 
