Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZHZRNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZHZRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZHZRN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:13:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:28513 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZHZRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lPvwZLi2ypT4AOuFcdcVt6OeMFppJ1fMztLLYqt0XMh4i29/9j3xthB0TgLym933Ps
         mA4RgSb4tFakhNK9Pt2PFhnvfQeADZWrouXOB+EoLUdqGFa3cFHKkD4B2YDPdWqFQSHm
         v056BK0H7cRQVFaCll0WKZsoBf1hzEtGPF+LI=
Date: Wed, 26 Aug 2009 21:13:24 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Cc: x86team <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86,acpi: early_init_lapic_mapping - slim down stack usage
Message-ID: <20090826171324.GC4548@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I see there is no external poking of
mp_lapic_addr in this procedure which could lead
to unpredited changes and require local storage
unit for it. Lets use it plain forward.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1562,8 +1562,6 @@ no_apic:
 #ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
 {
-	unsigned long phys_addr;
-
 	/*
 	 * If no local APIC can be found then go out
 	 * : it means there is no mpatable and MADT
@@ -1571,11 +1569,9 @@ void __init early_init_lapic_mapping(voi
 	if (!smp_found_config)
 		return;
 
-	phys_addr = mp_lapic_addr;
-
-	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
+	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, phys_addr);
+		    APIC_BASE, mp_lapic_addr);
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
