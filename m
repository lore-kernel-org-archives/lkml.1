Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZDYAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZDYAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZDYAJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:09:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446AbZDYAJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:09:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 04/17] arm: tracehook_signal_handler
Message-Id: <20090425000906.BFB7DFC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:09:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes arm call the standard tracehook_signal_handler() hook
in <linux/tracehook.h> after setting up a signal handler.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/signal.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 80b8b5c..51e2187 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -12,6 +12,7 @@
 #include <linux/personality.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/tracehook.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -606,6 +607,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 	recalc_sigpending();
 	spin_unlock_irq(&tsk->sighand->siglock);
 
+	tracehook_signal_handler(sig, info, ka, regs, 0);
 }
 
 /*
