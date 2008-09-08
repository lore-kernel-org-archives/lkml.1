Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYIHPtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYIHPtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYIHPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:49:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:47356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYIHPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=S2bd5KagXE5w4cACmFgMqzNZC6w6EzreKW1ZINanN2hYenJfKDapxpVXexQ/XAVMKt
         wGMg45Qxk2m/SKZ6vL7ScRZja4SSjzONcIqURbnZQVybJIOeg34TmI325kk/aao6OOdA
         Ze5qI7J35Ix0PT0bQ+lDYwT4KMNSOzqpi3l6U=
Date: Mon, 8 Sep 2008 19:38:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH] x86: io-apic - do not use KERN_DEBUG marker too much
Message-ID: <20080908153806.GB7278@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use KERN_DEBUG several times on the same line being printed.
Introduced by mine previous patch, sorry.

Reported-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-08 19:32:34.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-08 19:34:10.000000000 +0400
@@ -1526,11 +1526,16 @@ static void __init setup_IO_APIC_irqs(vo
 
 			idx = find_irq_entry(apic, pin, mp_INT);
 			if (idx == -1) {
-				apic_printk(APIC_VERBOSE,
-					KERN_DEBUG " %d-%d",
-					mp_ioapics[apic].mp_apicid, pin);
-				if (!notcon)
+				if (!notcon) {
 					notcon = 1;
+					apic_printk(APIC_VERBOSE,
+						KERN_DEBUG " %d-%d",
+						mp_ioapics[apic].mp_apicid,
+						pin);
+				} else
+					apic_printk(APIC_VERBOSE, " %d-%d",
+						mp_ioapics[apic].mp_apicid,
+						pin);
 				continue;
 			}
 
@@ -1546,14 +1551,14 @@ static void __init setup_IO_APIC_irqs(vo
 		}
 		if (notcon) {
 			apic_printk(APIC_VERBOSE,
-				KERN_DEBUG " (apicid-pin) not connected\n");
+				" (apicid-pin) not connected\n");
 			notcon = 0;
 		}
 	}
 
 	if (notcon)
 		apic_printk(APIC_VERBOSE,
-			KERN_DEBUG " (apicid-pin) not connected\n");
+			" (apicid-pin) not connected\n");
 }
 
 /*
