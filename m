Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZG1X4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZG1X4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZG1X4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:56:51 -0400
Received: from kroah.org ([198.145.64.141]:35834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZG1XuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:57 2009
Message-Id: <20090728234157.690467627@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Andres Salomon <dilinger@debian.org>
Subject: [patch 42/71] x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-geode-mark-mfgpt-irq-irqf_timer-to-prevent-resume-failure.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit d6c585a4342a2ff627a29f9aea77c5ed4cd76023 upstream.

Timer interrupts are excluded from being disabled during suspend. The
clock events code manages the disabling of clock events on its own
because the timer interrupt needs to be functional before the resume
code reenables the device interrupts.

The mfgpt timer request its interrupt without setting the IRQF_TIMER
flag so suspend_device_irqs() disables it as well which results in a
fatal resume failure.

Adding IRQF_TIMER to the interupt flags when requesting the mrgpt
timer interrupt solves the problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Andres Salomon <dilinger@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/mfgpt_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -347,7 +347,7 @@ static irqreturn_t mfgpt_tick(int irq, v
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "mfgpt-timer"
 };
 


