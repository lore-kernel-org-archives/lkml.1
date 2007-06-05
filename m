Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXFEP20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXFEP20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363AbXFEP2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:28:09 -0400
Received: from ozlabs.org ([203.10.76.45]:37499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbXFEP2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:28:05 -0400
Subject: [PATCH 3/6] lguest suppress IDE probing
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>
In-Reply-To: <1181055396.14054.38.camel@localhost.localdomain>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 00:58:03 +1000
Message-Id: <1181055483.14054.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The IDE probe is the slowest part of boot: by suppressing it we cut
boot from from 3 seconds to half a second.

AFAICT, the commandline is the easiest way to suppress the probing.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |    6 ++++++
 1 file changed, 6 insertions(+)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -605,6 +605,12 @@ __init void lguest_init(void *boot)
 	acpi_disabled = 1;
 	acpi_ht = 0;
 #endif
+#ifdef CONFIG_BLK_DEV_IDE
+	/* Saves three seconds off boot time. */
+	strcat(boot_command_line,
+	       " ide0=noprobe ide1=noprobe ide2=noprobe"
+	       " ide3=noprobe ide4=noprobe ide5=noprobe");
+#endif
 
 	add_preferred_console("hvc", 0, NULL);
 


