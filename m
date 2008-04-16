Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbYDPSCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbYDPSCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYDPSCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:02:33 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:45786
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750887AbYDPSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:02:32 -0400
Date: Wed, 16 Apr 2008 11:02:31 -0700
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Cc: muli@il.ibm.com, jeff@garzik.org
Subject: [PATCH] Add back bfsort quirks when ACPI enabled
Message-ID: <20080416180231.GA27292@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fc5429f0838782acdfc5d2c6ab54a07951ea8ab2
Author: Phil Oester <kernel@linuxace.com>
Date:   Wed Apr 16 13:45:35 2008 -0400

    In commit 08f1c192c3c32797068bfe97738babb3295bbf42 (x86-64: introduce
    struct pci_sysdata to facilitate sharing of ->sysdata), a change was
    made from using pcibios_scan_root to pci_scan_bus_parented.  At this
    point, various quirks applied in pciprobe_dmi_table were no longer
    applied if ACPI was enabled.  This caused various devices to reverse
    their probe order between .22 and .23.
    
    The patch below simply copies the quirks from pciprobe_dmi_table to
    acpi_pciprobe_dmi_table so they will be applied again.  This makes
    probe order return to pre-23 behavior.  Not the most elegant solution
    to have the quirks in two places, but better than the current backwards
    ordering.
    
    Signed-off-by: Phil Oester <kernel@linuxace.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 378136f..0689408 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -42,6 +42,190 @@ static struct dmi_system_id acpi_pciprobe_dmi_table[] __devinitdata = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
 		},
 	},
+#ifdef __i386__
+/*
+ * Laptops which need pci=assign-busses to see Cardbus cards
+ */
+	{
+		.callback = assign_all_busses,
+		.ident = "Samsung X20 Laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SX20S"),
+		},
+	},
+	{
+		.callback = assign_all_busses,
+		.ident = "Compaq EVO N800c",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EVO N800c"),
+		},
+	},
+#endif		/* __i386__ */
+/*
+ * Systems requiring breadth-first PCI scanning
+ */
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 1950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1950"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 1955",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1955"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 2900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge 2950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2950"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge R900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G3"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G4"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL30p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL30p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL25p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL25p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL35p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL35p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL460c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL460c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL465c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL465c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL480c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL480c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL685c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
 	{}
 };
 
