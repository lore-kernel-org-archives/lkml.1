Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372Ab0CMSNw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 13:13:52 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43745 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab0CMSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 13:13:43 -0500
Subject: [PATCH v2 1/3] ipmi: Raise precedence of PNP based discovery
	mechanisms (ACPI, PCI)
To: minyard@acm.org
From: Myron Stowe <myron.stowe@hp.com>
Cc: linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Date: Sat, 13 Mar 2010 11:13:42 -0700
Message-ID: <20100313181342.20614.72981.stgit@bob.kio>
In-Reply-To: <20100313180121.20614.92547.stgit@bob.kio>
References: <20100313180121.20614.92547.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This raises the precedence of PNP discovery mechanisms, ACPI and  PCI,
above SMBIOS and SPMI as indicated by Appendix C1 of the IPMI
specification.

Reference: IPMI - Intelligent Platform Management Interface Specification
           v2.0, Document Revision 1.0, 05.05.2005 Markup

  Appendix C1 - Locating IPMI System Interfaces via SMBIOS Tables
      "Note that the settings that this structure reports may be over-
      ridden by `Plug-and-Play' reassignment by the OS.  Therefore, this
      structure should be used only when the interface cannot be
      discovered via `Plug-and-Play' discovery mechanisms incorporated
      in interfaces such as PCI and ACPI."

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
---

 drivers/char/ipmi/ipmi_si_intf.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 176f175..86a7dd7 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3197,13 +3197,6 @@ static __devinit int init_ipmi_si(void)
 
 	hardcode_find_bmc();
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
-
-#ifdef CONFIG_ACPI
-	spmi_find_bmc();
-#endif
 #ifdef CONFIG_ACPI
 	pnp_register_driver(&ipmi_pnp_driver);
 #endif
@@ -3220,6 +3213,14 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
+#ifdef CONFIG_DMI
+	dmi_find_bmc();
+#endif
+
+#ifdef CONFIG_ACPI
+	spmi_find_bmc();
+#endif
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {

