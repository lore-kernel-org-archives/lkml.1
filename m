Return-Path: <linux-kernel-owner+w=401wt.eu-S1765537AbXEUTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765537AbXEUTW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765010AbXEUTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46217 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764496AbXEUTVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:04 -0400
Message-Id: <20070521191743.327100000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick.Schoeller@hp.com, minyard@acm.org
Subject: [patch 45/69] IPMI: fix SI address space settings
Content-Disposition: inline; filename=ipmi-fix-si-address-space-settings.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Corey Minyard <minyard@acm.org>

Fix a rather obvious error that Patrick found in the setup routines.  Need to
set the proper address space in the ACPI case.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21.1.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.21.1/drivers/char/ipmi/ipmi_si_intf.c
@@ -1859,10 +1859,10 @@ static __devinit int try_init_acpi(struc
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		info->io_setup = mem_setup;
-		info->io.addr_type = IPMI_IO_ADDR_SPACE;
+		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 	} else if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
 		info->io_setup = port_setup;
-		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
+		info->io.addr_type = IPMI_IO_ADDR_SPACE;
 	} else {
 		kfree(info);
 		printk("ipmi_si: Unknown ACPI I/O Address type\n");

-- 
