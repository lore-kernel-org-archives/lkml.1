Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYIVJgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYIVJgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYIVJgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:36:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYIVJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fnZ/2ZfwwMa9E4+MJizJZYa5oEuW83Z/spxf98UawtggglmkxpGI9MAaWHdGSklV/9
         2sKOJaHda7F49UKnS7UtLA3BNjjEtoGcwRdIT1W1kue1+KnBo78VKirYjJdutoyVzGe/
         dlhXUgpx4HS2maMpf4mywYAkqSrINAK0d71lA=
Date: Mon, 22 Sep 2008 13:36:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: do_boot_cpu - add check if we have ESR register
Message-ID: <20080922093603.GC7663@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should touch ESR register if only we have one.
Check its presence first.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-18 19:17:16.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-22 13:30:36.000000000 +0400
@@ -893,8 +893,10 @@ do_rest:
 		/*
 		 * Be paranoid about clearing APIC errors.
 	 	*/
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
+		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+			apic_write(APIC_ESR, 0);
+			apic_read(APIC_ESR);
+		}
 	}
 
 	/*
