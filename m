Return-Path: <linux-kernel-owner+w=401wt.eu-S936111AbYD1SOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936111AbYD1SOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbYD1SOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:14:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1362 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765987AbYD1SOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:14:41 -0400
Message-ID: <4816140F.50005@ct.jp.nec.com>
Date: Mon, 28 Apr 2008 11:14:39 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt 1/4] x86_64: send NMI after nmi_show_regs on
References: <48161325.1080508@ct.jp.nec.com>
In-Reply-To: <48161325.1080508@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The flags nmi_show_regs should be set before send NMI.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index d187ab9..69cc737 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -327,11 +327,11 @@ void nmi_show_all_regs(void)
 	if (system_state == SYSTEM_BOOTING)
 		return;
 
-	smp_send_nmi_allbutself();
-
 	for_each_online_cpu(i)
 		nmi_show_regs[i] = 1;
 
+	smp_send_nmi_allbutself();
+
 	for_each_online_cpu(i) {
 		while (nmi_show_regs[i] == 1)
 			barrier();
-- 
1.5.4.1
