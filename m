Return-Path: <linux-kernel-owner+w=401wt.eu-S1030716AbXCFXir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716AbXCFXir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030717AbXCFXir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:38:47 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:12965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030716AbXCFXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:38:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c+EXfL1aNIbwINsHuPgByNf05C46Z/f2/hcZ38Fvqn8YdLfjd5DiDIG5qMMk75ZSSjRz42DBX+bhMgCE73z4atw6QB/40jYVnaf340xQ5Jf5IfChqiwyt2iPnUXGnxIG4P9zenamdim7si7mEVUmTHCNKEnh6e4jIhyOs4wQBGM=
Message-ID: <3424dc900703061538q564de10y4ea47dc97a7cc96@mail.gmail.com>
Date: Tue, 6 Mar 2007 15:38:46 -0800
From: "Anthony Godshall, Ampro Computers, Inc." <agodshall@ampro.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI disabled due to DMI failure or blacklisted year should be noted, as is done with other ACPI blacklisting
In-Reply-To: <3424dc900703061527i6153573wc7b932dd69c50f6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3424dc900703061527i6153573wc7b932dd69c50f6d@mail.gmail.com>
X-Google-Sender-Auth: cc0b9bae08957a71
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

IMHO, ACPI disabled due to DMI failure or blacklisted year should be
noted, as is done with other ACPI blacklisting.

This will help people troubleshoot when ACPI isn't working.  Status
quo is a mysterious "ACPI Disabled" message without explanation on
BIOS that implements ACPI but not DMI.  This is actually fairly common
on embedded x86 boards.

Tony

--- blacklist.orig.c    2007-02-04 10:44:54.000000000 -0800
+++ blacklist.tg.c      2007-03-06 10:57:18.000000000 -0800
@@ -79,11 +79,17 @@
 {
        int year = dmi_get_year(DMI_BIOS_DATE);
        /* Doesn't exist? Likely an old system */
-       if (year == -1)
+       if (year == -1) {
+               printk(KERN_ERR PREFIX "no DMI BIOS year, "
+                      "acpi=force is required to enable ACPI\n" );
                return 1;
+       }
        /* 0? Likely a buggy new BIOS */
-       if (year == 0)
+       if (year == 0) {
+               printk(KERN_ERR PREFIX "DMI BIOS year==0, "
+                      "assuming ACPI-capable machine\n" );
                return 0;
+       }
        if (year < CONFIG_ACPI_BLACKLIST_YEAR) {
                printk(KERN_ERR PREFIX "BIOS age (%d) fails cutoff (%d), "
                       "acpi=force is required to enable ACPI\n",

--
--
Tony Godshall
g
