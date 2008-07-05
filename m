Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYGEL5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYGEL5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYGEL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:30922 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYGEL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=DG7MmF3u961+X2bjxOUcwqQNT1qZYsmwn9jQYVpRf4VDqbB4KcNHrAPgrkeV0jzN9j
         Q/Cwz2X0jSYGgpcO5ADpT3LGbjsClACadd4SNu2u1kS8Ha1S3lY42RFYsov/Kqf+loYL
         NLkrBuSWSQXuzRqxx5x01m3DoJgIS3PVW4xAs=
References: <20080705115334.892720771@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/5] x86: ACPI - add checking for NULL early param
Content-Disposition: inline; filename=ep-acpi
Message-ID: <486f61a9.2135440a.0d16.ffffbd7f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/drivers/acpi/tables.c
====================================================================
--- linux-2.6.git.orig/drivers/acpi/tables.c	2008-01-21 23:14:47.000000000 +0300
+++ linux-2.6.git/drivers/acpi/tables.c	2008-07-05 12:24:16.000000000 +0400
@@ -300,6 +300,8 @@ int __init acpi_table_init(void)
 
 static int __init acpi_parse_apic_instance(char *str)
 {
+	if (!str)
+		return -EINVAL;
 
 	acpi_apic_instance = simple_strtoul(str, NULL, 0);
 

-- 
