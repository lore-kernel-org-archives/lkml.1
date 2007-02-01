Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbXBAPfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbXBAPfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXBAPfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:35:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:34335 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751714AbXBAPfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:35:32 -0500
Date: Thu, 1 Feb 2007 16:35:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/10] CRIS: local_irq_disable() is redundant after local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011612030.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

CRIS: local_irq_disable() is redundant after local_irq_save()

arch/cris/arch-v10/kernel/time.c::get_ns_in_jiffie() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

arch/cris/kernel/time.c::do_gettimeofday() contains
local_irq_disable() call after local_irq_save(). This looks
redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 arch/cris/arch-v10/kernel/time.c |    1 -
 arch/cris/kernel/time.c          |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index ebacf14..077e973 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -38,7 +38,6 @@ unsigned long get_ns_in_jiffie(void)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 	timer_count = *R_TIMER0_DATA;
 	presc_count = *R_TIM_PRESC_STATUS;  
 	/* presc_count might be wrapped */
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 0f9213c..22a1aa5 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -55,7 +55,6 @@ void do_gettimeofday(struct timeval *tv)
 	unsigned long flags;
 	signed long usec, sec;
 	local_irq_save(flags);
-	local_irq_disable();
 	usec = do_gettimeoffset();
 
         /*
