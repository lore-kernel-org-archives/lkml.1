Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYAYFzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYAYFzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYAYFyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:54:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:31890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbYAYFyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="293040698"
Subject: [PATCH 3/6] x86: early_ioremap_reset fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:54:58 +0800
Message-Id: <1201240498.15972.45.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:15.0626 (UTC) FILETIME=[B7B7E2A0:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of early_ioremap_reset.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/ioremap_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -285,7 +285,7 @@ void __init early_ioremap_reset(void)
 	pte_t *pte;
 
 	after_paging_init = 1;
-	for (idx = FIX_BTMAP_BEGIN; idx <= FIX_BTMAP_END; idx--) {
+	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
 		addr = fix_to_virt(idx);
 		pte = early_ioremap_pte(addr);
 		if (pte_present(*pte)) {

