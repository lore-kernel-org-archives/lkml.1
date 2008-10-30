Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYJ3VCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYJ3VCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYJ3VCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:02:03 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56446 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbYJ3VCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:02:00 -0400
Subject: [PATCH] fix ACPI induced voyager compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:01:58 -0500
Message-Id: <1225400518.19324.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c339b7cdc39399855ec07dfbff67304f9c7fa49a Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 10:58:13 -0500
Subject: [VOYAGER] x86: don't pull asm/acpi.h into fixmap_32.h

If it's not needed it causes compile failures.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/fixmap_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
index 09f29ab..c3302ee 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -25,7 +25,9 @@ extern unsigned long __FIXADDR_TOP;
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#ifdef CONFIG_ACPI
 #include <asm/acpi.h>
+#endif
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #ifdef CONFIG_HIGHMEM
-- 
1.5.6.5



