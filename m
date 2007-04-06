Return-Path: <linux-kernel-owner+w=401wt.eu-S1767646AbXDFNtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767646AbXDFNtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767649AbXDFNtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:49:03 -0400
Received: from www.osadl.org ([213.239.205.134]:36381 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767646AbXDFNtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:49:00 -0400
Subject: [PATCH] Deprecate SA_xxx interrupt flags -V2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1169584278.21181.86.camel@localhost.localdomain>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de>
	 <20070114081926.912658228@inhelltoy.tec.linutronix.de>
	 <20070123120245.ec3b0772.akpm@osdl.org>
	 <1169584278.21181.86.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 15:49:26 +0200
Message-Id: <1175867366.28263.454.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The deprecation of the SA_xxx interrupt flags did not emit deprecated
warnings. Andrew said about the removal of the deprecated flag defines:

> This is going to break a lot of external stuff.  We should have found
> a way to make usage of SA_* emit deprecated warnings (or _some_
> warning) to warn people of impending doom.  But I can't immediately
> find a way of doing that. if we _can_ find a way of doing this, I
> suspect we'll need to do it, and give people another six months.  It's
> going to get ugly out there.  We shall see...

Define the deprecated flags as a call to a __deprecated inline function
so a warning is emitted on compile time.

Extend the reprieve of out of tree drivers to 9/2007.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0bc8b0b..2a531ea 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -171,7 +171,7 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
 ---------------------------
 
 What:	Interrupt only SA_* flags
-When:	Januar 2007
+When:	September 2007
 Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
 	out of the signal namespace.
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 838cf5a..3a72071 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -54,20 +54,26 @@
 #define IRQF_NOBALANCING	0x00000800
 
 /*
- * Migration helpers. Scheduled for removal in 1/2007
+ * Migration helpers. Scheduled for removal in 9/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+static inline
+unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
+{
+	return flag;
+}
+
+#define SA_INTERRUPT		deprecated_irq_flag(IRQF_DISABLED)
+#define SA_SAMPLE_RANDOM	deprecated_irq_flag(IRQF_SAMPLE_RANDOM)
+#define SA_SHIRQ		deprecated_irq_flag(IRQF_SHARED)
+#define SA_PROBEIRQ		deprecated_irq_flag(IRQF_PROBE_SHARED)
+#define SA_PERCPU		deprecated_irq_flag(IRQF_PERCPU)
+
+#define SA_TRIGGER_LOW		deprecated_irq_flag(IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_HIGH		deprecated_irq_flag(IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_FALLING	deprecated_irq_flag(IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_RISING	deprecated_irq_flag(IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_MASK		deprecated_irq_flag(IRQF_TRIGGER_MASK)
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 


