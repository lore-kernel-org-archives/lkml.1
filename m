Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZGPKyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZGPKyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZGPKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:54:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:56134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZGPKyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="533343887"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:54:33 -0700
Subject: [PATCH v2 1/10] x86/boot: adding hw subarch ID for Moorestown
Thread-Topic: [PATCH v2 1/10] x86/boot: adding hw subarch ID for Moorestown
Thread-Index: AcoGA81QhqG4OKM/To22OqmAMIacaQ==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF3@orsmsx508.amr.corp.intel.com>
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

>From b328ba482b8683d6438f3290f46c4e46fb7492a2 Mon Sep 17 00:00:00 2001
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

