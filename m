Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYKNVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYKNVUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYKNVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:20:21 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:38291 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYKNVUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:20:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=hcHOm/Ao/Gp1Szf+dnRMJTSHefaVIdnCfXxOiRbOm+/MJH/A9W1BWgkjzLggELIIq5fZDsHlYbsQo8njnh25M0czk+EcBRg+cG4QTegSx5Y26c5rcAuNkrXkoMwUFwWE;
Message-ID: <491DEB90.9010509@simon.arlott.org.uk>
Date: Fri, 14 Nov 2008 21:20:16 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.17 (X11/20080928)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
CC: sheng.yang@intel.com
Subject: [PATCH] x86: add REQUIRED_MASK8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e38e05a85828dac23540cd007df5f20985388afc increased NCAPINTS to 9
but didn't add REQUIRED_MASK8 resulting in the following sparse warnings:

arch/x86/boot/cpustr.h:311:5: warning: undefined preprocessor identifier 'REQUIRED_MASK8'
arch/x86/boot/cpustr.h:314:5: warning: undefined preprocessor identifier 'REQUIRED_MASK8'
arch/x86/boot/cpustr.h:317:5: warning: undefined preprocessor identifier 'REQUIRED_MASK8'
arch/x86/boot/cpustr.h:320:5: warning: undefined preprocessor identifier 'REQUIRED_MASK8'
arch/x86/boot/cpustr.h:323:5: warning: undefined preprocessor identifier 'REQUIRED_MASK8'

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/boot/cpucheck.c                 |    1 +
 arch/x86/include/asm/cpufeature.h        |    3 ++-
 arch/x86/include/asm/required-features.h |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff03..41559bf 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -44,6 +44,7 @@ static const u32 req_flags[NCAPINTS] =
 	0, /* REQUIRED_MASK5 not implemented in this file */
 	REQUIRED_MASK6,
 	0, /* REQUIRED_MASK7 not implemented in this file */
+	0 /* REQUIRED_MASK8 not implemented in this file */
 };
 
 #define A32(a, b, c, d) (((d) << 24)+((c) << 16)+((b) << 8)+(a))
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index cfdf8c2..9761800 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -178,7 +178,8 @@ extern const char * const x86_power_flags[32];
 	   (((bit)>>5)==4 && (1UL<<((bit)&31) & REQUIRED_MASK4)) ||	\
 	   (((bit)>>5)==5 && (1UL<<((bit)&31) & REQUIRED_MASK5)) ||	\
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
-	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) )	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
+	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) )	\
 	  ? 1 :								\
 	 test_cpu_cap(c, bit))
 
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index d5cd6c5..0baa45d 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -78,5 +78,6 @@
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
+#define REQUIRED_MASK8	0
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
-- 
1.6.0.3

-- 
Simon Arlott
