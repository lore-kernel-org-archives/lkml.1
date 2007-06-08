Return-Path: <linux-kernel-owner+w=401wt.eu-S939634AbXFHHxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939634AbXFHHxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938173AbXFHHZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:17 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55346 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967641AbXFHHZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:06 -0400
Message-Id: <20070608072224.040409000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tim Gardner <tim.gardner@ubuntu.com>,
       Matt_Domsch@dell.com, ak@suse.de, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 39/54] Work around Dell E520 BIOS reboot bug
Content-Disposition: inline; filename=work-around-dell-e520-bios-reboot-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tim Gardner <tim.gardner@ubuntu.com>

Force Dell E520 to use the BIOS to shutdown/reboot.

I have at least one report that this patch fixes shutdown/reboot
problems on the Dell E520 platform.

(Andi says: People can always set the boot option.  It hardly seems like a
critical issue needing a backport.)

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Acked-by: Andi Kleen <ak@suse.de>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>


---
 arch/i386/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.21.4.orig/arch/i386/kernel/reboot.c
+++ linux-2.6.21.4/arch/i386/kernel/reboot.c
@@ -88,6 +88,14 @@ static int __init set_bios_reboot(struct
 }
 
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Dell E520's */
+		.callback = set_bios_reboot,
+		.ident = "Dell E520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 1300's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 1300",

-- 
