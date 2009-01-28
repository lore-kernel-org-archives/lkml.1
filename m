Return-Path: <linux-kernel-owner+w=401wt.eu-S1763775AbZA2ATb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763775AbZA2ATb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758655AbZA1Xqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:53299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005AbZA1Xqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:39 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 088/114] x86/Voyager: remove KVM Kconfig quirk
Date: Wed, 28 Jan 2009 23:42:34 +0000
Message-Id: <1233186180-29883-89-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager and other subarchitectures have this Kconfig quirk:

 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)

This is unnecessary, as KVM cleanly detects based on CPUID capabilities.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9727dd5..a783fe7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -34,7 +34,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
+	select HAVE_KVM
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
-- 
1.6.0.2

