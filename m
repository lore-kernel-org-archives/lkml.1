Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZJKPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZJKPnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZJKPnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:43:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:50781 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZJKPnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:43:14 -0400
Date: Sun, 11 Oct 2009 08:43:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       hpa@zytor.com
Subject: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED
Message-ID: <20091011084311.0ab3c3ea@infradead.org>
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

>From 3385e0ae9596dc0538023166c800b0f8d2accce2 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 11 Oct 2009 08:40:15 -0700
Subject: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED

PAT support (which got added to CPUs over 10 years ago) is no longer
really optional in that more and more things are depending on PAT
just working, including newer versions of X. Having this as a regular
config option just no longer makes sense.

This patch relegates CONFIG_PAT to the EMBEDDED category, in the hope
to eventually completely retire it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4427956..16d9d40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1393,7 +1393,8 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	bool
-	prompt "x86 PAT support"
+	default y
+	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
