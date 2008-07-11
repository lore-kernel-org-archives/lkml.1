Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYGKUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYGKUDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYGKUD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:03:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57858 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYGKUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:03:26 -0400
Date: Fri, 11 Jul 2008 12:57:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] acpi_pm clccksource: fix printk format warning
Message-Id: <20080711125731.770dd278.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: tglx@linutronix.de

Fix printk format warning in acpi_pm clocksource:

linux-next-20080711/drivers/clocksource/acpi_pm.c:231: warning: format '%04lx' expects type 'long unsigned int', but argument 2 has type 'u32'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/clocksource/acpi_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20080711.orig/drivers/clocksource/acpi_pm.c
+++ linux-next-20080711/drivers/clocksource/acpi_pm.c
@@ -227,8 +227,8 @@ static int __init parse_pmtmr(char *arg)
 	if (strict_strtoul(arg, 16, &base))
 		return -EINVAL;
 
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04lx -> 0x%04lx\n",
-	       pmtmr_ioport, base);
+	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
+	       (unsigned int)pmtmr_ioport, base);
 	pmtmr_ioport = base;
 
 	return 1;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
