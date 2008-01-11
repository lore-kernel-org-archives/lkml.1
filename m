Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYAKI5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYAKI5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbYAKI5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:57:42 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31408
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757612AbYAKI5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:57:40 -0500
Message-Id: <47873DA5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:57:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH 3/4] use __devinitconst on x86
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch probably doesn't change all instances where 'const' could
have been added as a result of the base structure changes, only where
the change has a real effect (the module loader doesn't enforce
read-only section attributes at present, so only built-in files make a
real difference).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/pci/acpi.c   |    2 +-
 arch/x86/pci/common.c |    2 +-
 arch/x86/pci/fixup.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- 2.6.24-rc7-initconst.orig/arch/x86/pci/acpi.c
+++ 2.6.24-rc7-initconst/arch/x86/pci/acpi.c
@@ -13,7 +13,7 @@ static int __devinit can_skip_ioresource
 	return 0;
 }
 
-static struct dmi_system_id acpi_pciprobe_dmi_table[] __devinitdata = {
+static struct dmi_system_id __devinitconst acpi_pciprobe_dmi_table[] = {
 /*
  * Systems where PCI IO resource ISA alignment can be skipped
  * when the ISA enable bit in the bridge control is not set
--- 2.6.24-rc7-initconst.orig/arch/x86/pci/common.c
+++ 2.6.24-rc7-initconst/arch/x86/pci/common.c
@@ -147,7 +147,7 @@ static int __devinit assign_all_busses(c
 }
 #endif
 
-static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
+static struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 #ifdef __i386__
 /*
  * Laptops which need pci=assign-busses to see Cardbus cards
--- 2.6.24-rc7-initconst.orig/arch/x86/pci/fixup.c
+++ 2.6.24-rc7-initconst/arch/x86/pci/fixup.c
@@ -354,7 +354,7 @@ static void __devinit pci_fixup_video(st
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
 
 
-static struct dmi_system_id __devinitdata msi_k8t_dmi_table[] = {
+static struct dmi_system_id __devinitconst msi_k8t_dmi_table[] = {
 	{
 		.ident = "MSI-K8T-Neo2Fir",
 		.matches = {
@@ -411,7 +411,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  */
 static u16 toshiba_line_size;
 
-static struct dmi_system_id __devinitdata toshiba_ohci1394_dmi_table[] = {
+static struct dmi_system_id __devinitconst toshiba_ohci1394_dmi_table[] = {
 	{
 		.ident = "Toshiba PS5 based laptop",
 		.matches = {



