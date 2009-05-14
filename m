Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbZENHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbZENHm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbZENHl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:41:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:49424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760860AbZENHl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:41:26 -0400
Subject: [PATCH 4/6] x86: mtrr remove mtrr MSRs double declaration
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1242286549.4574.19.camel@localhost.localdomain>
References: <1242286304.4574.15.camel@localhost.localdomain>
	 <1242286427.4574.17.camel@localhost.localdomain>
	 <1242286484.4574.18.camel@localhost.localdomain>
	 <1242286549.4574.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:06:44 +0530
Message-Id: <1242286604.4574.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


removed MTRR MSR from mtrr/mtrr.h as these are already decalared in
msr-index.h and no body is using them:
 MTRRfix16K_A0000_MSR
 MTRRfix4K_C8000_MSR
 MTRRfix4K_D0000_MSR
 MTRRfix4K_D8000_MSR
 MTRRfix4K_E0000_MSR
 MTRRfix4K_E8000_MSR
 MTRRfix4K_F0000_MSR
 MTRRfix4K_F8000_MSR

Use standard msr-index.h's MSR declaration and no need to declare again

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 712b605..5053793 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -7,15 +7,7 @@
 
 #define MTRRdefType_MSR 0x2ff
 
-#define MTRRfix16K_A0000_MSR 0x259
 #define MTRRfix4K_C0000_MSR 0x268
-#define MTRRfix4K_C8000_MSR 0x269
-#define MTRRfix4K_D0000_MSR 0x26a
-#define MTRRfix4K_D8000_MSR 0x26b
-#define MTRRfix4K_E0000_MSR 0x26c
-#define MTRRfix4K_E8000_MSR 0x26d
-#define MTRRfix4K_F0000_MSR 0x26e
-#define MTRRfix4K_F8000_MSR 0x26f
 
 #define MTRR_CHANGE_MASK_FIXED     0x01
 #define MTRR_CHANGE_MASK_VARIABLE  0x02
-- 
1.6.0.6



