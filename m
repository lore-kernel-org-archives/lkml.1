Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZCLMQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZCLMQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZCLMQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:16:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:44503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbZCLMQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:16:10 -0400
Date: Thu, 12 Mar 2009 12:15:29 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B909A5.76E4.0078.0@novell.com>
References: <49B909A5.76E4.0078.0@novell.com>
Subject: [tip:x86/debug] x86: move a few device initialization objects into .devinit.rodata
Message-ID: <tip-821508d4ef7920283b960057903505fed609fd16@git.kernel.org>
Git-Commit-ID: 821508d4ef7920283b960057903505fed609fd16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 12:15:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  821508d4ef7920283b960057903505fed609fd16
Gitweb:     http://git.kernel.org/tip/821508d4ef7920283b960057903505fed609fd16
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:09:57 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 13:12:19 +0100

x86: move a few device initialization objects into .devinit.rodata

Impact: debuggability and micro-optimization

Putting whatever is possible into the (final) .rodata section increases
the likelihood of catching memory corruption bugs early, and reduces
false cache line sharing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B909A5.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/pci/common.c |    4 ++--
 arch/x86/pci/fixup.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 82d22fc..8c362b9 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -90,7 +90,7 @@ static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
 	return 0;
 }
 
-static struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitdata = {
+static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitconst = {
 /*
  * Systems where PCI IO resource ISA alignment can be skipped
  * when the ISA enable bit in the bridge control is not set
@@ -183,7 +183,7 @@ static int __devinit assign_all_busses(const struct dmi_system_id *d)
 }
 #endif
 
-static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
+static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 #ifdef __i386__
 /*
  * Laptops which need pci=assign-busses to see Cardbus cards
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 7d388d5..9c49919 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -356,7 +356,7 @@ static void __devinit pci_fixup_video(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
 
 
-static struct dmi_system_id __devinitdata msi_k8t_dmi_table[] = {
+static const struct dmi_system_id __devinitconst msi_k8t_dmi_table[] = {
 	{
 		.ident = "MSI-K8T-Neo2Fir",
 		.matches = {
@@ -413,7 +413,7 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
  */
 static u16 toshiba_line_size;
 
-static struct dmi_system_id __devinitdata toshiba_ohci1394_dmi_table[] = {
+static const struct dmi_system_id __devinitconst toshiba_ohci1394_dmi_table[] = {
 	{
 		.ident = "Toshiba PS5 based laptop",
 		.matches = {
