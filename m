Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZF3LW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZF3LW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZF3LWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:22:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44966 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZF3LWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:22:52 -0400
Message-Id: <4A4A11AF020000780000831D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:22:55 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <tony.luck@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/ia64: adjust section annotation for
	 pcibios_setup()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function gets called from __init context only, so it can itself be
__init too.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/ia64/pci/pci.c   |    2 +-
 arch/x86/pci/common.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc1/arch/ia64/pci/pci.c	2009-06-26 17:49:37.000000000 +0200
+++ 2.6.31-rc1-pcibios_setup/arch/ia64/pci/pci.c	2009-05-04 11:39:32.000000000 +0200
@@ -537,7 +537,7 @@ pcibios_align_resource (void *data, stru
 /*
  * PCI BIOS setup, always defaults to SAL interface
  */
-char * __devinit
+char * __init
 pcibios_setup (char *str)
 {
 	return str;
--- linux-2.6.31-rc1/arch/x86/pci/common.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc1-pcibios_setup/arch/x86/pci/common.c	2009-05-04 11:39:32.000000000 +0200
@@ -439,7 +439,7 @@ int __init pcibios_init(void)
 	return 0;
 }
 
-char * __devinit  pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;



