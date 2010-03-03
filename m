Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0CCQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:16:27 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:36390 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0CCQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:16:26 -0500
Date: Wed, 03 Mar 2010 10:16:02 -0600
From: Corey Minyard <minyard@acm.org>
To: torvalds@linux-foundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Bela Lubkin <blubkin@vmware.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 2/4] IPMI: Fix slave_addrs setting to actually work
Message-id: <20100303161602.GB17623@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bela Lubkin <blubkin@vmware.com>

Actually use the slave_addrs module parameter if it is specified, and make
things consistent about passing zero in for the slave address for the
default.

Signed-off-by: Bela Lubkin <blubkin@vmware.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
---

Index: linux-2.6.30/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.30.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.30/drivers/char/ipmi/ipmi_si_intf.c
@@ -1179,7 +1179,7 @@ static int           regsizes[SI_MAX_PAR
 static unsigned int num_regsizes;
 static int           regshifts[SI_MAX_PARMS];
 static unsigned int num_regshifts;
-static int slave_addrs[SI_MAX_PARMS];
+static int slave_addrs[SI_MAX_PARMS]; /* Leaving 0 chooses the default value */
 static unsigned int num_slave_addrs;
 
 #define IPMI_IO_ADDR_SPACE  0
@@ -1647,7 +1647,7 @@ static int hotmod_handler(const char *va
 		regsize = 1;
 		regshift = 0;
 		irq = 0;
-		ipmb = 0x20;
+		ipmb = 0; /* Choose the default if not specified */
 
 		next = strchr(curr, ':');
 		if (next) {
@@ -1839,6 +1839,7 @@ static __devinit void hardcode_find_bmc(
 		info->irq = irqs[i];
 		if (info->irq)
 			info->irq_setup = std_irq_setup;
+		info->slave_addr = slave_addrs[i];
 
 		try_smi_init(info);
 	}
