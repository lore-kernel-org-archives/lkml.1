Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYHSEwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYHSEwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYHSEwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:52:34 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:45367 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYHSEwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:52:33 -0400
Message-Id: <48AA50EF.9010609@ct.jp.nec.com>
Date: Mon, 18 Aug 2008 21:49:51 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] rcuclassic: fix compilation NG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

  CC      kernel/rcuclassic.o
kernel/rcuclassic.c: In function '__rcu_process_callbacks':
kernel/rcuclassic.c:561: error: 'flags' undeclared (first use in this function)
kernel/rcuclassic.c:561: error: (Each undeclared identifier is reported only once
kernel/rcuclassic.c:561: error: for each function it appears in.)
kernel/rcuclassic.c:561: warning: type defaults to 'int' in declaration of '__dummy2'
kernel/rcuclassic.c:561: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:561: warning: type defaults to 'int' in declaration of '__dummy2'
kernel/rcuclassic.c:561: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:566: warning: type defaults to 'int' in declaration of '__dummy2'
kernel/rcuclassic.c:566: warning: comparison of distinct pointer types lacks a cast
kernel/rcuclassic.c:566: warning: type defaults to 'int' in declaration of '__dummy2'
kernel/rcuclassic.c:566: warning: comparison of distinct pointer types lacks a cast

Declare missing variable flagas.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/rcuclassic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index c6b6cf5..01e761a 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -557,6 +557,8 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 		local_irq_enable();
 
 		if (rcu_batch_after(rdp->batch, rcp->pending)) {
+			unsigned long flags;
+
 			/* and start it/schedule start if it's a new batch */
 			spin_lock_irqsave(&rcp->lock, flags);
 			if (rcu_batch_after(rdp->batch, rcp->pending)) {
