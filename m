Return-Path: <linux-kernel-owner+w=401wt.eu-S1762559AbZEOIsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762559AbZEOIsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761950AbZEOIp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:45:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:41165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761761AbZEOIpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:45:24 -0400
Date: Fri, 15 May 2009 08:44:12 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Remove ACPI quirk
Message-ID: <tip-251e8e3c7235f5944805a64f24c79fc4696793f1@git.kernel.org>
Git-Commit-ID: 251e8e3c7235f5944805a64f24c79fc4696793f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:44:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  251e8e3c7235f5944805a64f24c79fc4696793f1
Gitweb:     http://git.kernel.org/tip/251e8e3c7235f5944805a64f24c79fc4696793f1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 14 May 2009 05:16:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:07 +0200

perf_counter: Remove ACPI quirk

We had a disable/enable around acpi_idle_do_entry() due to an erratum
in an early prototype CPU i had access to. That erratum has been fixed
in the BIOS so remove the quirk.

The quirk also kept us from profiling interrupts that hit the ACPI idle
instruction - so this is an improvement as well, beyond a cleanup and
a micro-optimization.

[ Impact: improve profiling scope, cleanup, micro-optimization ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/acpi/processor_idle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 9645758..f7ca8c5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -765,7 +765,6 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
-	perf_disable();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -780,7 +779,6 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
-	perf_enable();
 	start_critical_timings();
 }
 
