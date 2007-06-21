Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbXFUAve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbXFUAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFUAvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:51:25 -0400
Received: from ccerelrim04.cce.hp.com ([161.114.21.25]:28559 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXFUAvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:51:24 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 20 Jun 2007 20:51:22 -0400
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
Message-ID: <20070621005122.GD10927@localhost>
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.6.20.173532
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:	[Wed Jun 20 2007, 01:14:34PM EDT]
[snip]

Build breakage. pci_mmcfg_late_init is for i386.

Signed-off-by: Bob Picco <bob.picco@hp.com>

 drivers/acpi/bus.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22-rc5-mm1/drivers/acpi/bus.c
===================================================================
--- linux-2.6.22-rc5-mm1.orig/drivers/acpi/bus.c	2007-06-20 14:09:07.000000000 -0400
+++ linux-2.6.22-rc5-mm1/drivers/acpi/bus.c	2007-06-20 20:32:00.000000000 -0400
@@ -757,7 +757,9 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
+#ifdef CONFIG_X86
 		pci_mmcfg_late_init();
+#endif
 #ifdef CONFIG_PM_LEGACY
 		if (!PM_IS_ACTIVE())
 			pm_active = 1;
