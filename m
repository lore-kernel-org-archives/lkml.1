Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYJTN1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYJTN1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYJTN1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:27:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYJTN1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:27:11 -0400
Date: Mon, 20 Oct 2008 15:26:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, akpm@linux-foundation.org,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [patch] x86, bts: improve help text for BTS config
Message-ID: <20081020132644.GB21316@elte.hu>
References: <20081017090927.A5454@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017090927.A5454@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Improve the help text of the X86_PTRACE_BTS config.
> Make X86_DS invisible and depend on X86_PTRACE_BTS.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

applied the patch below to tip/x86/urgent, thanks Markus! (only a small 
change, added the Reported-by: Roland Dreier line)

	Ingo

-------------->
>From e4254fd175d2ebaa7d72ce33245c41ca34370a7e Mon Sep 17 00:00:00 2001
From: Markus Metzger <markus.t.metzger@intel.com>
Date: Fri, 17 Oct 2008 09:09:27 +0200
Subject: [PATCH] x86, bts: improve help text for BTS config

Improve the help text of the X86_PTRACE_BTS config.
Make X86_DS invisible and depend on X86_PTRACE_BTS.

Reported-by: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 0b7c4a3..b815664 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -513,19 +513,19 @@ config CPU_SUP_UMC_32
 	  If unsure, say N.
 
 config X86_DS
-	bool "Debug Store support"
-	default y
-	help
-	  Add support for Debug Store.
-	  This allows the kernel to provide a memory buffer to the hardware
-	  to store various profiling and tracing events.
+	def_bool X86_PTRACE_BTS
+	depends on X86_DEBUGCTLMSR
 
 config X86_PTRACE_BTS
-	bool "ptrace interface to Branch Trace Store"
+	bool "Branch Trace Store"
 	default y
-	depends on (X86_DS && X86_DEBUGCTLMSR)
+	depends on X86_DEBUGCTLMSR
 	help
-	  Add a ptrace interface to allow collecting an execution trace
-	  of the traced task.
-	  This collects control flow changes in a (cyclic) buffer and allows
-	  debuggers to fill in the gaps and show an execution trace of the debuggee.
+	  This adds a ptrace interface to the hardware's branch trace store.
+
+	  Debuggers may use it to collect an execution trace of the debugged
+	  application in order to answer the question 'how did I get here?'.
+	  Debuggers may trace user mode as well as kernel mode.
+
+	  Say Y unless there is no application development on this machine
+	  and you want to save a small amount of code size.
