Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYHRVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYHRVk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYHRVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:39:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4302 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbYHRVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:39:46 -0400
Message-ID: <48A9EC09.4060701@ct.jp.nec.com>
Date: Mon, 18 Aug 2008 14:39:21 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip] rcuclassic: fix compiler warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

  CC      kernel/rcuclassic.o
kernel/rcuclassic.c: In function 'rcu_init_percpu_data':
kernel/rcuclassic.c:705: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:713: warning: comparison of distinct pointer types lacks a cast

flags should be unsigned long.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/rcuclassic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index fb1f1cc..86ff6d6 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -700,7 +700,7 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
-	long flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
-- 
1.5.6

