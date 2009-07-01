Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZGAMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZGAMWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZGAMW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:22:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZGAMW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:22:27 -0400
Subject: [PATCH -tip RESEND] x86: mm/init.c declare check_efer() before it
 get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 17:51:29 +0530
Message-Id: <1246450889.6940.10.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


check_efer() is already declared in asm/proto.h, so include it before using it.

Also fix sparse warning :

  CHECK   arch/x86/mm/init.c
  arch/x86/mm/init.c:83:16: warning: symbol 'check_efer' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1043590..d31f9e7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -12,6 +12,7 @@
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
+#include <asm/proto.h>
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-- 
1.6.0.6



