Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbXGTSwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbXGTSwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763911AbXGTSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:52:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50203 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762831AbXGTSwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:52:03 -0400
Subject: [PATCH] x86_64: Mark nmi_show_regs static
From: Josh Triplett <josh@kernel.org>
Reply-To: josh@kernel.org, josht@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:52:16 -0700
Message-Id: <1184957536.2630.21.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/x86_64/kernel/nmi.c uses nmi_show_regs, so mark it
static.

Eliminates a sparse warning introduced in -rt:
warning: symbol 'nmi_show_regs' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 arch/x86_64/kernel/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
index 5642567..fa33074 100644
--- a/arch/x86_64/kernel/nmi.c
+++ b/arch/x86_64/kernel/nmi.c
@@ -317,7 +317,7 @@ void touch_nmi_watchdog (void)
 	touch_softlockup_watchdog();
 }
 
-int nmi_show_regs[NR_CPUS];
+static int nmi_show_regs[NR_CPUS];
 
 void nmi_show_all_regs(void)
 {
-- 
1.5.2.1


