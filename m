Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZH1Vwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZH1Vwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZH1Vwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:52:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:23716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZH1Vwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:52:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208,223";a="545725260"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 28 Aug 2009 14:52:47 -0700
Subject: [PATCH 1/7] x86/boot: adding hw subarch ID for Moorestown
Thread-Topic: [PATCH 1/7] x86/boot: adding hw subarch ID for Moorestown
Thread-Index: AcoiuRd83/2R3UcXTbawIpHVij504QFbD2vQ
Message-ID: <43F901BD926A4E43B106BF17856F07556A5EA871@orsmsx508.amr.corp.intel.com>
References: <20090821205008.518392436@linutronix.de>
 <20090821205602.584376844@linutronix.de> <4A8F1FEA.1060706@goop.org>
 <alpine.LFD.2.00.0908220139390.1769@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908220139390.1769@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2de4f68e7b0403bb39954d7c2e3d5097d0e6e3ac Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 11 Jun 2009 20:34:47 -0700
Subject: [PATCH] x86/boot: adding hw subarch ID for Moorestown

x86 bootprotocol 2.07 has introduced hardware_subarch ID in the boot
parameters provided by FW. We use it to identify Moorestown platforms.

The subarchitecture ID will help select a set of platform features and
x86_quirks.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 Documentation/x86/boot.txt       |    1 +
 arch/x86/include/asm/bootparam.h |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 8da3a79..30b43e1 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -599,6 +599,7 @@ Protocol:	2.07+
   0x00000000	The default x86/PC environment
   0x00000001	lguest
   0x00000002	Xen
+  0x00000003	Moorestown MID
 
 Field name:	hardware_subarch_data
 Type:		write (subarch-dependent)
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 1724e8d..631cae9 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -109,4 +109,15 @@ struct boot_params {
 	__u8  _pad9[276];				/* 0xeec */
 } __attribute__((packed));
 
+#define N_X86_SUBARCHS			4
+
+enum {
+	X86_SUBARCH_PC = 0,
+	X86_SUBARCH_LGUEST,
+	X86_SUBARCH_XEN,
+	X86_SUBARCH_MRST,
+};
+
+
+
 #endif /* _ASM_X86_BOOTPARAM_H */
-- 
1.5.6.5

