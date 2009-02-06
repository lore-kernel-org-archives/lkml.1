Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZBFS6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZBFS6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZBFS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:57:55 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:57672 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZBFS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:57:54 -0500
Date: Fri, 06 Feb 2009 13:57:47 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Regression on VIA C3 motherboard, commit: 66f2173e2
In-reply-to: <498A93E5.2080509@candelatech.com>
Message-id: <alpine.LFD.2.00.0902061350470.26256@localhost.localdomain>
References: <498A93E5.2080509@candelatech.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the bisect, Ben.

Please test the patch below.

I assume even without the patch, booting with "acpi=off" on your
BIOS-ACPI-disabled box works?  (if no, this patch will not solve
all your problems, for you have additional trouble elsewhere)

I am curious why you're running a CONFIG_ACPI=y kernel
for a box with ACPI disabled. (though yes, it is supposed to work)

I'm even more curious what bad things happen when
you enable ACPI in the BIOS -- can you let me know
and we can try to fix them so the machine can run as shipped?

thanks,
-Len Brown
Intel Open Source Technology Center

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 775c97a..a885295 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -293,7 +293,12 @@ static void __init check_multiple_madt(void)
 
 int __init acpi_table_init(void)
 {
-	acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
+	acpi_status status;
+
+	status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
+	if (ACPI_FAILURE(status))
+		return 1;
+
 	check_multiple_madt();
 	return 0;
 }
