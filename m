Return-Path: <linux-kernel-owner+w=401wt.eu-S1423578AbXEAVZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423578AbXEAVZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423606AbXEAVZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:25:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423578AbXEAVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:25:51 -0400
Date: Tue, 1 May 2007 18:30:50 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unnecessary irq disabling
Message-ID: <20070501213050.GD6119@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

RR asks us if it is really necessary to disable interrupts in
setup_secondary_APIC_clock(). The answer is no, since setup_APIC_timer()
starts by saving irq flags, which also disables them.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="irq_disable.patch"

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 124b2d2..7eacd5f 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -875,9 +875,7 @@ void __init setup_boot_APIC_clock (void)
 
 void __cpuinit setup_secondary_APIC_clock(void)
 {
-	local_irq_disable(); /* FIXME: Do we need this? --RR */
 	setup_APIC_timer(calibration_result);
-	local_irq_enable();
 }
 
 void disable_APIC_timer(void)

--ZPt4rx8FFjLCG7dd--
