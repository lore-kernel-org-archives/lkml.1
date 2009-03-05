Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCEOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCEOTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCEOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:19:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:38822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZCEOTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:19:22 -0500
Date: Thu, 5 Mar 2009 14:18:48 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20090304185605.GA24419@sgi.com>
References: <20090304185605.GA24419@sgi.com>
Subject: [tip:x86/uv] x86: UV, SGI RTC: add generic system vector, build fix on UP
Message-ID: <tip-b2b352590d94651579e6914ecdb08d30b2cb5f19@git.kernel.org>
Git-Commit-ID: b2b352590d94651579e6914ecdb08d30b2cb5f19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 14:18:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2b352590d94651579e6914ecdb08d30b2cb5f19
Gitweb:     http://git.kernel.org/tip/b2b352590d94651579e6914ecdb08d30b2cb5f19
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Thu, 5 Mar 2009 15:15:44 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 15:15:56 +0100

x86: UV, SGI RTC: add generic system vector, build fix on UP

Make ack_APIC_irq() build on !SMP && !APIC too.

Cc: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20090304185605.GA24419@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 4ef949c..394d177 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -379,6 +379,7 @@ static inline u32 safe_apic_wait_icr_idle(void)
 
 static inline void ack_APIC_irq(void)
 {
+#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
@@ -386,6 +387,7 @@ static inline void ack_APIC_irq(void)
 
 	/* Docs say use 0 for future compatibility */
 	apic_write(APIC_EOI, 0);
+#endif
 }
 
 static inline unsigned default_get_apic_id(unsigned long x)
