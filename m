Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653Ab0AMWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0AMWcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638Ab0AMWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:32:22 -0500
Received: from [206.15.93.42] ([206.15.93.42]:11119 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032Ab0AMWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:32:21 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init/main.c: make setup_max_cpus static for !SMP
Date: Wed, 13 Jan 2010 15:32:22 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001131532.22596.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init/main.c: make setup_max_cpus static for !SMP

The only in tree external users of the symbol setup_max_cpus are in
arch/x86/. The files ./kernel/alternative.c, ./kernel/visws_quirks.c, and
./mm/kmemcheck/kmemcheck.c are all guarded by CONFIG_SMP
being defined. For this case the symbol is an unsigned int and
declared as an extern in include/linux/smp.h.

When CONFIG_SMP is not defined the symbol setup_max_cpus is
a constant value that is only used in init/main.c.  Make the symbol
static for this case.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/init/main.c b/init/main.c
index dac44a9..7110851 100644
--- a/init/main.c
+++ b/init/main.c
@@ -160,7 +160,7 @@ static int __init maxcpus(char *str)
 
 early_param("maxcpus", maxcpus);
 #else
-const unsigned int setup_max_cpus = NR_CPUS;
+static const unsigned int setup_max_cpus = NR_CPUS;
 #endif
 
 /*
