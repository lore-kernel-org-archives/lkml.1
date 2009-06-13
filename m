Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZFMQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZFMQia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765640AbZFMQiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:38:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:34499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765559AbZFMQiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:38:02 -0400
Subject: [RFC][PATCH 1/10 -tip] x86: cpu_debug update Kconfig entry
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1244910436.11733.14.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 21:58:31 +0530
Message-Id: <1244910511.11733.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu_debug needs DEBUG_FS.

Explain basic info to use cpu_debug.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/Kconfig |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c2321d..e5e26b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -994,9 +994,19 @@ config X86_CPUID
 
 config X86_CPU_DEBUG
 	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
+	select DEBUG_FS
 	---help---
 	  If you select this option, this will provide various x86 CPUs
-	  information through debugfs.
+	  information through debugfs. Any user can read these file but writing
+	  needs root privilege.
+
+	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
+	  automatically (like usual drivers). You will need to load it manually
+	  (or add it to list of modules loaded during boot).
+
+	  2. You need debugfs, if you want to mount debugfs automatically
+	  append this line in /etc/fstab:
+	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
 
 choice
 	prompt "High Memory Support"
-- 
1.6.0.6



