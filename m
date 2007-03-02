Return-Path: <linux-kernel-owner+w=401wt.eu-S2992486AbXCBOiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992486AbXCBOiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992487AbXCBOiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:38:22 -0500
Received: from mta16.adelphia.net ([68.168.78.211]:33422 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992486AbXCBOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:38:21 -0500
Date: Fri, 2 Mar 2007 08:38:19 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Christian Krafft <krafft@de.ibm.com>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] ipmi: check, if default ports are accessible on PPC
Message-ID: <20070302143818.GA5224@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Krafft <krafft@de.ibm.com>

ipmi_si_intf tries to access default ports, if no device could
be found elsewhere. On PPC we have a function to check,
if these legacy IO ports are accessible. This patch adds
a check for these ports on PPC.
This patch fixes a breakage of IPMI module
on PPC machines without a BMC.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Acked-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux/drivers/char/ipmi/ipmi_si_intf.c
@@ -2580,6 +2580,11 @@ static __devinit void default_find_bmc(v
 		if (!info)
 			return;
 
+#ifdef CONFIG_PPC_MERGE
+		if (check_legacy_ioport(ipmi_defaults[i].port))
+			continue;
+#endif
+
 		info->addr_source = NULL;
 
 		info->si_type = ipmi_defaults[i].type;
 

