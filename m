Return-Path: <linux-kernel-owner+w=401wt.eu-S1765201AbZA2A0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765201AbZA2A0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZA1XrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:53440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbZA1XrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:19 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 106/114] x86/Voyager: remove ISA quirk
Date: Wed, 28 Jan 2009 23:42:52 +0000
Message-Id: <1233186180-29883-107-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this ISA quirk (because Voyager has no ISA support):

 config ISA
 	bool "ISA support"
	depends on !X86_VOYAGER

There's a ton of x86 hardware that does not support ISA, and because
most ISA drivers cannot auto-detect in a safe way, the convention in
the kernel has always been to not enable ISA drivers if they are not
needed.

Voyager users can do likewise - no need for a Kconfig quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f95c3b4..38ed1a6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1819,7 +1819,6 @@ if X86_32
 
 config ISA
 	bool "ISA support"
-	depends on !X86_VOYAGER
 	help
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
 	  name of a bus system, i.e. the way the CPU talks to the other stuff
-- 
1.6.0.2

