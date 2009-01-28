Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbZA2AXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbZA2AXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbZA1XrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:53380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbZA1XrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:01 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 099/114] x86/Voyager: remove KVM_CLOCK quirk
Date: Wed, 28 Jan 2009 23:42:45 +0000
Message-Id: <1233186180-29883-100-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager has this build-time quirk to exclude KVM_CLOCK:

 	bool "KVM paravirtualized clock"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
	depends on !X86_VOYAGER

Voyager support built into a kernel image does not exclude
KVM paravirt clock support - so remove this quirk.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4bd0c8f..0bf0653 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -416,7 +416,6 @@ config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
-	depends on !X86_VOYAGER
 	help
 	  Turning on this option will allow you to run a paravirtualized clock
 	  when running over the KVM hypervisor. Instead of relying on a PIT
-- 
1.6.0.2

