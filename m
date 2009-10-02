Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZJBFPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZJBFPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZJBFPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:15:22 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:55390 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZJBFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nzFbn98leCXPhyF4poscqdZohNdSGOHfE5eF201qJrMdw4+7Wp9n1VUHfpeieRJPMc
         jA3Kh/0MctidhwSiqXom9GzwMpN//Dh2h+B0jF97ZbEVf2jlZWuCgaYK6vrNLBjf07ZN
         iyWKAUKWg+faEpdx4p2QeCWFN9AxNNf9noi5M=
MIME-Version: 1.0
Date: Fri, 2 Oct 2009 11:15:24 +0600
Message-ID: <b9df5fa10910012215u6f6cbb8w3a8e667aec43dab4@mail.gmail.com>
Subject: [PATCH] acpi: Annote acpi_processor_add with __cpuinit.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Annote acpi_processor_add with cpuinit since it calls a cpuinit function
acpi_processor_power_init and fixes a section mismatch warning.

 We were warned by the following warning:

 LD      drivers/acpi/processor.o
WARNING: drivers/acpi/processor.o(.text+0x1829): Section mismatch in
reference from the function acpi_processor_add() to the function
.cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

-------
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/acpi/processor_core.c	2009-09-28 12:04:54.000000000 +0600
+++ rakib/drivers/acpi/processor_core.c	2009-09-29 23:21:13.000000000 +0600
@@ -770,7 +770,7 @@ static struct notifier_block acpi_cpu_no
 	    .notifier_call = acpi_cpu_soft_notify,
 };

-static int acpi_processor_add(struct acpi_device *device)
+static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
