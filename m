Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbXJ2WK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbXJ2WK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXJ2WKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:10:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXJ2WKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:10:13 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, rusty@rustcorp.com.au, jeremy@goop.org,
       --cc@redhat.com, mingo@elte.hu, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] raise tsc clocksource rating
Date: Mon, 29 Oct 2007 20:10:09 -0300
Message-Id: <11936994092607-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber de Oliveira Costa <glauber@t60.localdomain>

tsc is very good time source (when it does not have drifts, does not
change it's frequency, i.e. when it works), so it should have its rating
raised to a value greater than, or equal 400.

Since it's being a tendency among paravirt clocksources to use values
around 400, we should declare tsc as even better: So we use 500.

This patch also touches the comments on clocksource.h, which suggests
that 499 would be a limit on the rating values.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc_32.c    |    2 +-
 arch/x86/kernel/tsc_64.c    |    2 +-
 include/linux/clocksource.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 9ebc0da..4d91e59 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -280,7 +280,7 @@ static cycle_t read_tsc(void)
 
 static struct clocksource clocksource_tsc = {
 	.name			= "tsc",
-	.rating			= 300,
+	.rating			= 500,
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9c70af4..4fd5b1b 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -262,7 +262,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 
 static struct clocksource clocksource_tsc = {
 	.name			= "tsc",
-	.rating			= 300,
+	.rating			= 500,
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 107787a..5b0aadd 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -39,7 +39,7 @@ struct clocksource;
  *				A correct and usable clocksource.
  *			300-399: Desired.
  *				A reasonably fast and accurate clocksource.
- *			400-499: Perfect
+ *			>= 400 : Perfect
  *				The ideal clocksource. A must-use where
  *				available.
  * @read:		returns a cycle value
-- 
1.5.0.6

