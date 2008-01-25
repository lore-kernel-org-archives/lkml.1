Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYAYFzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYAYFzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYAYFyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:54:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:31890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbYAYFye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:54:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="293040694"
Subject: [PATCH 2/6] x86: make early_ioremap_debug early_param
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:54:55 +0800
Message-Id: <1201240495.15972.44.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:12.0688 (UTC) FILETIME=[B5F79500:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes "early_ioremap_debug" a early parameter, because
"early_ioreamp/early_iounmap" is only used during early boot stage.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/ioremap_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/ioremap_32.c
+++ b/arch/x86/mm/ioremap_32.c
@@ -215,9 +215,9 @@ static int __init early_ioremap_debug_se
 {
 	early_ioremap_debug = 1;
 
-	return 1;
+	return 0;
 }
-__setup("early_ioremap_debug", early_ioremap_debug_setup);
+early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
 static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]

