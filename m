Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbZELPuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbZELPuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZELPsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:48:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:51154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680AbZELPsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:48:10 -0400
Subject: [PATCH 9/10 -tip] x86: collect_cpu_info() of Intel user of
 Microcode feature
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142996.2547.22.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam>  <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam>  <1242142908.2547.20.camel@ht.satnam>
	 <1242142941.2547.21.camel@ht.satnam>  <1242142996.2547.22.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:14:01 +0530
Message-Id: <1242143041.2547.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use X86_FEATURE_MICROCODE to determine microcode update

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/microcode_intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..c2e128e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -161,8 +161,8 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64)) {
+	if (c->x86_vendor != X86_VENDOR_INTEL ||
+	    !cpu_has(c, X86_FEATURE_MICROCODE)) {
 		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
 			"processor\n", cpu_num);
 		return -1;
-- 
1.6.0.6



