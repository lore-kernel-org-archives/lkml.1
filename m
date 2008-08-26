Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYHZUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYHZUAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYHZUAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:00:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:2886 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYHZUAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sxAHk3SZqhjUdAANRr0VFTi1hjwtScRqjCugDwVk+ihywtzS35EFJl9tH/vIUkkdqk
         EjxJetRozYy04LScVHrlqojtc0xtZm0fRjwcRv69xbiYGIJxrS9FzXUTuzBdtLR//IKE
         uMP1M60bXEdpHi9IFJwcRUaVGDc8HdowLutXk=
Subject: [PATCH 1/2] rcu: spinlocks take an unsigned long flags
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Aug 2008 13:00:44 -0700
Message-Id: <1219780844.6069.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
kernel/rcuclassic.c:719:2: error: incompatible types in comparison expression (different signedness)
kernel/rcuclassic.c:727:2: error: incompatible types in comparison expression (different signedness)
kernel/rcuclassic.c: In function ‘rcu_init_percpu_data’:
kernel/rcuclassic.c:719: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:727: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/rcuclassic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 3f69189..743cf05 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -714,7 +714,7 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
-	long flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&rcp->lock, flags);
 	memset(rdp, 0, sizeof(*rdp));
-- 
1.6.0.340.g84854


