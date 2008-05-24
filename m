Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYEXPnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYEXPnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYEXPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYEXPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=U3rziPNf6IEyRcUQKseI+zQ4WI/6O/Rn6SwzTe+XSAP2Jb4KlvvB+vvfIYtOr45iX0+hG/uKS6AbsIJL2PiqU3prxf/s+JHAoKA1JkR4uIOqH3P5xWygxoKYUI6gIfU1m/Trwh7LLKg79GUEwOKbIOiUJzoVOOyKiZCprMvkS1c=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead of apic_write
Content-Disposition: inline; filename=nmi-use-apic-write-around
Message-ID: <48383740.0407560a.4764.7d1b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_write_around will be expanded to apic_write in 64bit mode
anyway. Only a few CPUs (well, old CPUs to be precise) requires
such an action. In general it should not hurt and could be cleaned
up for apic_write (just in case)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:04:20.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 13:07:08.000000000 +0400
@@ -248,7 +248,7 @@ void acpi_nmi_enable(void)
 
 static void __acpi_nmi_disable(void *__unused)
 {
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
 }
 
 /*
Index: linux-2.6.git/arch/x86/kernel/nmi_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_64.c	2008-05-24 13:02:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_64.c	2008-05-24 13:07:44.000000000 +0400
@@ -215,7 +215,7 @@ late_initcall(init_lapic_nmi_sysfs);
 
 static void __acpi_nmi_enable(void *__unused)
 {
-	apic_write(APIC_LVT0, APIC_DM_NMI);
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
 }
 
 /*
@@ -229,7 +229,7 @@ void acpi_nmi_enable(void)
 
 static void __acpi_nmi_disable(void *__unused)
 {
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
 }
 
 /*

-- 
