Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZJFOFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZJFOFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbZJFOFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:05:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:41515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbZJFOFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:05:02 -0400
Date: Tue, 6 Oct 2009 07:04:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Don't use the strict copy checks when branch profiling
 is in use
Message-ID: <20091006070452.5e1fc119@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 3719b55e3091ad2cf8c2cfc358223c2b749ff3fd Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 6 Oct 2009 07:02:10 -0700
Subject: [PATCH] x86: Don't use the strict copy checks when branch profiling is in use

The branch profiling creates very complex code for each if statement,
to the point that gcc has trouble even analyzing something as simple
as

if (count > 5)
    count = 5;

This then means that causing an error on code that gcc cannot analyze
for copy_from_user() and co is not very productive.

This patch excludes the strict copy checks in the case of branch
profiling being enabled.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1bd2e36..fb772b6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -289,7 +289,7 @@ config OPTIMIZE_INLINING
 
 config DEBUG_STRICT_USER_COPY_CHECKS
 	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
 	---help---
 	  Enabling this option turns a certain set of sanity checks for user
 	  copy operations into compile time failures.
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
