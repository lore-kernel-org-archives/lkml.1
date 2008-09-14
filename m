Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYINOmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYINOmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYINOm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:42:27 -0400
Received: from gw.goop.org ([64.81.55.164]:34042 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYINOm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:42:27 -0400
Message-ID: <48CD22CF.9030900@goop.org>
Date: Sun, 14 Sep 2008 07:42:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roberto@unbit.it, jeremy@xensource.com, linux-kernel@vger.kernel.org,
       Mirko Iannella <mirko@unbit.it>, Alex Nixon <alex.nixon@citrix.com>
Subject: [PATCH] xen: Fix for xen guest with mem > 3.7G
References: <1221333418.6036.9.camel@sirius> <48CC2C12.4080302@goop.org> <20080914132104.GB32106@elte.hu>
In-Reply-To: <20080914132104.GB32106@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PFN_PHYS() can truncate large addresses unless its passed a suitable
large type.  This is fixed more generally in the patch series
introducing phys_addr_t, but we need a short-term fix to solve a
regression.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: roberto@unbit.it
---
 arch/x86/xen/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -42,7 +42,7 @@
 
 	e820.nr_map = 0;
 
-	e820_add_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
 
 	/*
 	 * Even though this is normal, usable memory under Xen, reserve


