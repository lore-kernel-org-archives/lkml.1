Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZCLMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZCLMKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZCLMJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:09:19 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36372 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbZCLMJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:09:18 -0400
Message-Id: <49B909A5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:09:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move a few device initialization objects into
	 .devinit.rodata
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: debuggability and micro-optimization

Putting whatever is possible into the (final) .rodata section increases
the likelihood of catching memory corruption bugs early, and reduces
false cache line sharing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/pci/common.c |    4 ++--
 arch/x86/pci/fixup.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.29-rc7/arch/x86/pci/common.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-devinitconst-x86/arch/x86/pci/common.c	2009-02-13 12:31:59.000000000 +0100
@@ -90,7 +90,7 @@ static int __devinit can_skip_ioresource
 	return 0;
 }
 
-static struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitdata = {
+static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitconst = {
 /*
  * Systems where PCI IO resource ISA alignment can be skipped
  * when the ISA enable bit in the bridge control is not set
@@ -183,7 +183,7 @@ static int __devinit assign_all_busses(c
 }
 #endif
 
-static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
+static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 #ifdef __i386__
 /*
  * Laptops which need pci=assign-busses to see Cardbus cards
--- linux-2.6.29-rc7/arch/x86/pci/fixup.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-devinitconst-x86/arch/x86/pci/fixup.c	2009-02-13 12:31:59.000000000 +0100
@@ -356,7 +356,7 @@ static void __devinit pci_fixup_video(st
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
 
 
-static struct dmi_system_id __devinitdata msi_k8t_dmi_table[] = {
+static const struct dmi_system_id __devinitconst msi_k8t_dmi_table[] = {
 	{
 		.ident = "MSI-K8T-Neo2Fir",
 		.matches = {
@@ -413,7 +413,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_V
  */
 static u16 toshiba_line_size;
 
-static struct dmi_system_id __devinitdata toshiba_ohci1394_dmi_table[] = {
+static const struct dmi_system_id __devinitconst toshiba_ohci1394_dmi_table[] = {
 	{
 		.ident = "Toshiba PS5 based laptop",
 		.matches = {



