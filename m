Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYDRXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYDRXXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYDRXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:22:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44213 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDRXWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:47 -0400
Message-Id: <2c534626fe10b5c62c552cdacd96e07e94e232ca.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: davem@davemloft.net
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/15] [SPARC] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:46 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- mark timer_interrupt() static

- sparc_floppy_request_irq() prototype should use irq_handler_t

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/sparc/kernel/time.c   |    2 +-
 include/asm-sparc/floppy.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/time.c b/arch/sparc/kernel/time.c
index cfaf22c..53caacb 100644
--- a/arch/sparc/kernel/time.c
+++ b/arch/sparc/kernel/time.c
@@ -105,7 +105,7 @@ __volatile__ unsigned int *master_l10_limit;
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 {
 	/* last time the cmos clock got updated */
 	static long last_rtc_update;
diff --git a/include/asm-sparc/floppy.h b/include/asm-sparc/floppy.h
index dbe7a58..d3978e0 100644
--- a/include/asm-sparc/floppy.h
+++ b/include/asm-sparc/floppy.h
@@ -280,7 +280,7 @@ static inline void sun_fd_enable_dma(void)
 
 /* Our low-level entry point in arch/sparc/kernel/entry.S */
 extern int sparc_floppy_request_irq(int irq, unsigned long flags,
-				    irqreturn_t (*irq_handler)(int irq, void *));
+				    irq_handler_t irq_handler);
 
 static int sun_fd_request_irq(void)
 {
-- 
1.5.4.1

