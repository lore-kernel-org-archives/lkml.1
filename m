Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbYBHN2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbYBHN2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbYBHN2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:28:00 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56871 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144AbYBHN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:27:59 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208227.168531243@suse.de>
In-Reply-To: <20080208227.168531243@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/5] Don't use inline for the protection checks
Message-Id: <20080208132747.39C121B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 14:27:47 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 13:21:26.0951 (UTC) FILETIME=[8237AB70:01C86A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are multiple call sites and they are not time critical

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -156,7 +156,7 @@ static unsigned long virt_to_highmap(voi
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t
+static pgprot_t
 required_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
 {
 	pgprot_t forbidden = __pgprot(0);
@@ -188,7 +188,7 @@ required_static_prot(pgprot_t prot, unsi
 	return prot;
 }
 
-static inline pgprot_t
+static pgprot_t
 advised_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_DEBUG_RODATA
