Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbYBAROu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbYBAROu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYBAROn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:14:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:1915 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbYBAROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gjhJlCBDEhoYRHDSi/rde2zcSdiYLvpWPMk6aWa6PXqPIX01iBIKOomKik/KhVsODpSpkrA9yFHMSp9ET6V9u0EvTXInx+NSroJ+FmwMyOx7dXw9QaDfFELjAFd8WLugzkh4Zv0mtYy0urUeAgGi4lbTWzYkUIz6EYBi52Jkkho=
Date: Fri, 1 Feb 2008 20:14:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanup - eliminate numbers in LDT allocation code
Message-ID: <20080201171422.GA6730@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates numbers in LDT allocation code
trying to make it clear to understand from where
these numbers are go

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

I hope nobody shoot me ;)

Index: linux-2.6.git/arch/x86/kernel/ldt.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/ldt.c	2008-02-01 19:30:01.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/ldt.c	2008-02-01 19:38:32.000000000 +0300
@@ -35,7 +35,8 @@ static int alloc_ldt(mm_context_t *pc, i
 	if (mincount <= pc->size)
 		return 0;
 	oldsize = pc->size;
-	mincount = (mincount + 511) & (~511);
+	mincount = (mincount + (PAGE_SIZE / LDT_ENTRY_SIZE - 1)) &
+			(~(PAGE_SIZE / LDT_ENTRY_SIZE - 1));
 	if (mincount * LDT_ENTRY_SIZE > PAGE_SIZE)
 		newldt = vmalloc(mincount * LDT_ENTRY_SIZE);
 	else
