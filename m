Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYHSXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYHSXyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYHSXyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:54:02 -0400
Received: from gw.goop.org ([64.81.55.164]:53210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHSXyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:54:01 -0400
Message-ID: <48AB5D17.5030600@goop.org>
Date: Tue, 19 Aug 2008 16:53:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11313] Plugging HDMI causes "unable to handle kernel paging
 request"
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>	 <sNRO-BDDjQL.A.DYF.sazpIB@albercik> <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
In-Reply-To: <b170af450808171228i37951c6vd77071da7584669b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> Bug still exists in current git (tested 15 minutes ago).
>   

Could you apply this patch and post the output of dmesg from booting (no
need to crash it again).

Thanks,
    J

diff -r 3f465c361b3c arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c	Wed Aug 13 20:50:10 2008 -0700
+++ b/arch/x86/mm/init_64.c	Tue Aug 19 16:50:10 2008 -0700
@@ -331,6 +331,8 @@
 		}
 
 		if (pmd_val(*pmd)) {
+			printk("addr %lx reusing pmd %lx %016lx\n",
+			       address, __pa(pmd), pmd_val(*pmd));
 			if (!pmd_large(*pmd))
 				last_map_addr = phys_pte_update(pmd, address,
 								 end);
@@ -392,6 +394,8 @@
 		}
 
 		if (pud_val(*pud)) {
+			printk("addr %lx reusing pud %lx %016lx\n",
+			       addr, __pa(pud), pud_val(*pud));
 			if (!pud_large(*pud))
 				last_map_addr = phys_pmd_update(pud, addr, end,
 							 page_size_mask);
@@ -500,6 +504,8 @@
 			next = end;
 
 		if (pgd_val(*pgd)) {
+			printk("addr %lx reusing pgd %lx %016lx\n",
+			       __pa(start), __pa(pgd), pgd_val(*pgd));
 			last_map_addr = phys_pud_update(pgd, __pa(start),
 						 __pa(end), page_size_mask);
 			continue;


