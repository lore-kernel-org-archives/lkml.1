Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZHPQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZHPQ4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZHPQ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:56:19 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:43961 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZHPQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc
         :disposition-notification-to:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Ti76O7hEx6Pyrj/qQXjWNumN0qnvBjvKJmIYDvQqu8MZoN2dR8mJ7Q7dT7VNs4kl9m
         6Wkw82rz7An0cWA07jIJRyoVLRLlkBQTNSOP2S/0mpwZ3X/RZNcHcin8tO+gQzFutaSu
         uRMZHkZa7Qthnuf/On/sGu0TZzIn/GDq7NLx0=
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: fix section mismatch warnings in kernel/apic/x2apic_uv_x.c
Date: Sun, 16 Aug 2009 18:55:48 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-smp1; KDE/4.3.0; x86_64; ; )
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908161855.48302.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

The function uv_acpi_madt_oem_check() has been marked __init, the struct apic_x2apic_uv_x has been marked __refdata.
The aim is to remove the following section mismatch messages:

WARNING: arch/x86/kernel/apic/built-in.o(.data+0x1368): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: arch/x86/kernel/built-in.o(.data+0x68e8): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: arch/x86/built-in.o(.text+0x7b36f): Section mismatch in reference from the function uv_acpi_madt_oem_check() to the function .init.text:early_ioremap()
The function uv_acpi_madt_oem_check() references
the function __init early_ioremap().
This is often because uv_acpi_madt_oem_check lacks a __init 
annotation or the annotation of early_ioremap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7b38d): Section mismatch in reference from the function uv_acpi_madt_oem_check() to the function .init.text:early_iounmap()
The function uv_acpi_madt_oem_check() references
the function __init early_iounmap().
This is often because uv_acpi_madt_oem_check lacks a __init 
annotation or the annotation of early_iounmap is wrong.

WARNING: arch/x86/built-in.o(.data+0x8668): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-08-16 17:48:15.000000000 +0200
+++ linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c	2009-08-16 17:52:05.000000000 +0200
@@ -46,7 +46,7 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
-static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
 		if (!strcmp(oem_table_id, "UVL"))
@@ -253,7 +253,7 @@ static void uv_send_IPI_self(int vector)
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-struct apic apic_x2apic_uv_x = {
+struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= NULL,
