Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXJOSjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXJOSjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764756AbXJOSeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:47819 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933909AbXJOSeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:10 -0400
Message-ID: <4713B274.1030505@windriver.com>
Date: Mon, 15 Oct 2007 13:33:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ak@suse.de
Subject: [PATCH 11/21] KGDB: This adds a call to notify_die()
Content-Type: multipart/mixed;
 boundary="------------010202050301090106030208"
X-OriginalArrivalTime: 15 Oct 2007 18:34:07.0656 (UTC) FILETIME=[F88D1280:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202050301090106030208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------010202050301090106030208
Content-Type: text/x-patch;
 name="x86_64-no_context_hook.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_64-no_context_hook.patch"

x86_64-no_context_hook.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: ak@suse.de
Subject: [PATCH] This adds a call to notify_die()

A call to notify_die is added in the "no context" portion of
do_page_fault() as someone on the chain might care and want to do a
fixup.

Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/mm/fault_64.c      |    4 ++++
 include/asm-x86/kdebug_64.h |    1 +
 2 files changed, 5 insertions(+)

--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -531,6 +531,10 @@ no_context:
 	if (is_errata93(regs, address))
 		return; 
 
+	if (notify_die(DIE_PAGE_FAULT_NO_CONTEXT, "no context", regs,
+				error_code, 14, SIGSEGV) == NOTIFY_STOP)
+		return;
+
 /*
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
--- a/include/asm-x86/kdebug_64.h
+++ b/include/asm-x86/kdebug_64.h
@@ -23,6 +23,7 @@ enum die_val {
 	DIE_CALL,
 	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
+	DIE_PAGE_FAULT_NO_CONTEXT,
 };
 
 extern void printk_address(unsigned long address);

--------------010202050301090106030208--
