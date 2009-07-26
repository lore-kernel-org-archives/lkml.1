Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZGZIYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZGZIYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZGZIYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:24:43 -0400
Received: from www.tglx.de ([62.245.132.106]:34165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZGZIYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:24:41 -0400
Message-Id: <20090726081556.547609319@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [Patch RFC 25/37] net: wan/cosa.c: Convert "mutex" to semaphore
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-net-wan-cosa-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completions in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/wan/cosa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/wan/cosa.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/wan/cosa.c
+++ linux-2.6-tip/drivers/net/wan/cosa.c
@@ -574,7 +574,7 @@ static int cosa_probe(int base, int irq,
 
 		/* Initialize the chardev data structures */
 		mutex_init(&chan->rlock);
-		init_MUTEX(&chan->wsem);
+		semaphore_init(&chan->wsem);
 
 		/* Register the network interface */
 		if (!(chan->netdev = alloc_hdlcdev(chan))) {


