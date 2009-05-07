Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZEGW3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZEGW3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763132AbZEGW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:35559 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753807AbZEGW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470437"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 06/14] x86: add a Kconfig symbol for when relocations are needed
Date: Thu,  7 May 2009 15:26:54 -0700
Message-Id: <1241735222-6640-7-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

We only need to build relocations when we are building a 32-bit
relocatable kernel.  Rather than unnecessarily complicating the
Makefiles, make an explicit Kbuild symbol for this.

[ Impact: permits future cleanup ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13b3a5a..cd76de1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1516,6 +1516,11 @@ config RELOCATABLE
 	  it has been loaded at and the compile time physical address
 	  (CONFIG_PHYSICAL_START) is ignored.
 
+# Relocation on x86-32 needs some additional build support
+config X86_NEED_RELOCS
+	def_bool y
+	depends on X86_32 && RELOCATABLE
+
 config PHYSICAL_ALIGN
 	hex
 	prompt "Alignment value to which kernel should be aligned" if X86_32
-- 
1.6.0.6

