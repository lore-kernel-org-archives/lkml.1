Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZCBWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZCBWCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZCBWCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:02:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:32780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbZCBWCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:02:02 -0500
Date: Mon, 2 Mar 2009 22:01:20 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236006812.5330.632.camel@laptop>
References: <1236006812.5330.632.camel@laptop>
Subject: [tip:irq/genirq] genirq: assert that irq handlers are indeed running in hardirq context
Message-ID: <tip-3427ce9e6aac783a576c8e2712c323eaddd123a9@git.kernel.org>
Git-Commit-ID: 3427ce9e6aac783a576c8e2712c323eaddd123a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 02 Mar 2009 22:01:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3427ce9e6aac783a576c8e2712c323eaddd123a9
Gitweb:     http://git.kernel.org/tip/3427ce9e6aac783a576c8e2712c323eaddd123a9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 2 Mar 2009 16:13:32 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Mar 2009 22:59:15 +0100

genirq: assert that irq handlers are indeed running in hardirq context

Make sure the genirq layer handlers are indeed running handlers
in hardirq context. That is the genirq expectation and doing
anything else is broken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1236006812.5330.632.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/handle.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3aba8d1..716f4f4 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -328,6 +328,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
+	BUG_ON(!in_irq());
+
 	if (!(action->flags & IRQF_DISABLED))
 		local_irq_enable_in_hardirq();
 
