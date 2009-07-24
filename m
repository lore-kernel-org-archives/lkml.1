Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZGXGqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZGXGqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZGXGqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:46:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZGXGqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:46:43 -0400
Date: Fri, 24 Jul 2009 06:46:16 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, dilinger@debian.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dilinger@debian.org
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/urgent] x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
Message-ID: <tip-d6c585a4342a2ff627a29f9aea77c5ed4cd76023@git.kernel.org>
Git-Commit-ID: d6c585a4342a2ff627a29f9aea77c5ed4cd76023
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 24 Jul 2009 06:46:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6c585a4342a2ff627a29f9aea77c5ed4cd76023
Gitweb:     http://git.kernel.org/tip/d6c585a4342a2ff627a29f9aea77c5ed4cd76023
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 24 Jul 2009 08:34:59 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 24 Jul 2009 08:42:52 +0200

x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure

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
Cc: stable@kernel.org


---
 arch/x86/kernel/mfgpt_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 846510b..2a62d84 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -347,7 +347,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "mfgpt-timer"
 };
 
