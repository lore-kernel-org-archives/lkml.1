Return-Path: <linux-kernel-owner+w=401wt.eu-S966856AbXGaD4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966856AbXGaD4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXGaDzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:55:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940514AbXGaDzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:55:45 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] create CONFIG_SUSPEND_UP_POSSIBLE
Date: Mon, 30 Jul 2007 23:54:22 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707292323.29601.rjw@sisk.pl> <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707291717410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302354.23237.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Without this change, it is possible to build CONFIG_HIBERNATE
on all !SMP architectures, but not necessarily their SMP versions.

I don't know for sure if the architecture list under SUSPEND_UP_POSSIBLE
is correct.  For now it simply matches the list for SUSPEND_SMP_POSSIBLE.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 Kconfig |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 412859f..ccf6576 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -72,6 +72,11 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
+config SUSPEND_UP_POSSIBLE
+	bool
+	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
+	default y
+
 config SUSPEND_SMP_POSSIBLE
 	bool
 	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
@@ -92,7 +97,7 @@ config PM_SLEEP
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM
-	depends on !SMP || SUSPEND_SMP_POSSIBLE
+	depends on (!SMP && SUSPEND_UP_POSSIBLE) || (SMP && SUSPEND_SMP_POSSIBLE)
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
