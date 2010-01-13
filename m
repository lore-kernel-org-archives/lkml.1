Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369Ab0AMUpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0AMUpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427Ab0AMUpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:45:39 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:43271 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab0AMUpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:45:39 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Section mismatch: acpi_early_processor_set_pdc()
Date: Wed, 13 Jan 2010 22:44:48 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc4; KDE/4.2.4; x86_64; ; )
Cc: Rusty Russell <rusty@rustycorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Ashok Raj <ashok.raj@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001132244.49209.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

kernel-2.6.33-rc4, compiler output:

WARNING: Section mismatch in reference from the function 
acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table                                                                                           
The function acpi_early_processor_set_pdc() references                                                                            
the variable __cpuinitdata processor_idle_dmi_table.                                                                              
This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata                                                          
annotation or the annotation of processor_idle_dmi_table is wrong.   

acpi_early_processor_set_pdc() is invoked only from __init acpi_bus_init()  
Mark it __cpuinit.

The patch is against 2.6.33-rc4

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

===========================================================================
--- a/drivers/acpi/processor_pdc.c	2010-01-13 21:53:14.000000000 +0200
+++ b/drivers/acpi/processor_pdc.c	2010-01-13 21:58:39.000000000 +0200
@@ -151,7 +151,7 @@
 	return AE_OK;
 }
 
-void acpi_early_processor_set_pdc(void)
+void __cpuinit acpi_early_processor_set_pdc(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
