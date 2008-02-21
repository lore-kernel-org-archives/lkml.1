Return-Path: <linux-kernel-owner+w=401wt.eu-S1765764AbYBUP4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765764AbYBUP4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbYBUPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:20 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41311
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758294AbYBUPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:17 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 04/14] disable PREEMPT_SPINLOCK_WAITERS when x86
	ticket/fifo spins are in use
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:26:46 -0500
Message-ID: <20080221152646.4804.1627.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preemptible spinlock waiters effectively bypasses the benefits of a fifo
spinlock.  Since we now have fifo spinlocks for x86 enabled, disable the
preemption feature on x86.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Nick Piggin <npiggin@suse.de>
---

 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8d15667..d5b9a67 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	bool
 	default y
 	select HAVE_MCOUNT
+	select DISABLE_PREEMPT_SPINLOCK_WAITERS
 
 config GENERIC_TIME
 	bool

