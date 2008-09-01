Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYIAXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYIAXSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYIAXP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:45037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYIAXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:55 -0400
Date: Mon, 1 Sep 2008 16:09:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 6/13] hrtimer: convert powerpc/oprofile to the new hrtimer
 apis
Message-ID: <20080901160900.502a3b3a@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert powerpc/oprofile to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts powerpc/oprofile to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/powerpc/oprofile/cell/spu_profiler.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/oprofile/cell/spu_profiler.c b/arch/powerpc/oprofile/cell/spu_profiler.c
index 380d7e2..02ffe06 100644
--- a/arch/powerpc/oprofile/cell/spu_profiler.c
+++ b/arch/powerpc/oprofile/cell/spu_profiler.c
@@ -196,7 +196,7 @@ int start_spu_profiling(unsigned int cycles_reset)
 	pr_debug("timer resolution: %lu\n", TICK_NSEC);
 	kt = ktime_set(0, profiling_interval);
 	hrtimer_init(&timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	timer.expires = kt;
+	hrtimer_set_expires(&timer, kt);
 	timer.function = profile_spus;
 
 	/* Allocate arrays for collecting SPU PC samples */
-- 
1.5.5.1

