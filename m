Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZHRQwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZHRQwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbZHRQwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:52:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:42205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbZHRQwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:52:12 -0400
Date: Tue, 18 Aug 2009 16:51:36 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
References: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
Subject: [tip:x86/urgent] i386: Fix section mismatches for init code with !HOTPLUG_CPU
Message-ID: <tip-78b89ecd731798f2fec8cc26ca90739253cec33c@git.kernel.org>
Git-Commit-ID: 78b89ecd731798f2fec8cc26ca90739253cec33c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:51:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78b89ecd731798f2fec8cc26ca90739253cec33c
Gitweb:     http://git.kernel.org/tip/78b89ecd731798f2fec8cc26ca90739253cec33c
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 18 Aug 2009 16:41:33 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 17:52:35 +0200

i386: Fix section mismatches for init code with !HOTPLUG_CPU

Commit 0e83815be719d3391bf5ea24b7fe696c07dbd417 changed the
section the initial_code variable gets allocated in, in an
attempt to address a section conflict warning. This, however
created a new section conflict when building without
HOTPLUG_CPU. The apparently only (reasonable) way to address
this is to always use __REFDATA.

Once at it, also fix a second section mismatch when not using
HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/head_32.S |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0d98a01..cc827ac 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -261,9 +261,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
  * which will be freed later
  */
 
-#ifndef CONFIG_HOTPLUG_CPU
-.section .init.text,"ax",@progbits
-#endif
+__CPUINIT
 
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
@@ -602,11 +600,7 @@ ignore_int:
 #endif
 	iret
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__CPUINITDATA
-#else
 	__REFDATA
-#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
