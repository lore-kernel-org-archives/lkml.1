Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYHSQzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYHSQzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYHSQzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:55:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18496 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYHSQy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:54:59 -0400
X-IronPort-AV: E=Sophos;i="4.32,236,1217822400"; 
   d="scan'208";a="16524028"
Message-ID: <48AAFAE4.7070409@citrix.com>
Date: Tue, 19 Aug 2008 17:55:00 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] X86:  Change the default value of nr_irqs from 32 to NR_IRQs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2008 16:54:59.0095 (UTC) FILETIME=[50937270:01C9021C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>
Date: Tue, 19 Aug 2008 17:49:37 +0100
Subject: [PATCH] X86:  Change the default value of nr_irqs from 32 to NR_IRQs

If the number of discovered IRQs is suspiciously low, this patch causes the number reported to default to NR_IRQS, rather than 32.  NR_IRQS has already been defined to be a sensible value for the current system (in particular, at least 224 when paravirtualisation is involved).

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
---
 arch/x86/kernel/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 30ff794..11bffa1 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3632,7 +3632,7 @@ int __init probe_nr_irqs(void)
 
 	/* something wrong ? */
 	if (nr < 32)
-		nr = 32;
+		nr = NR_IRQS;
 
 	return nr;
 }
-- 
1.5.4.3

