Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZEMDJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZEMDJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZEMDGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:07 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36223
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755634AbZEMDGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:01 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/10] xen/pci: clean up Kconfig a bit
Date: Tue, 12 May 2009 14:48:10 -0700
Message-Id: <1242164891-3859-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242164891-3859-1-git-send-email-jeremy@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cut down on the maze of PCI-related config options.

[Impact: cleanup]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/Kconfig     |    4 ++--
 arch/x86/xen/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15cc23a..3d9d2cb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1830,8 +1830,8 @@ config PCI_OLPC
 	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
 config PCI_XEN
-	def_bool y
-	depends on XEN_PCI_PASSTHROUGH || XEN_DOM0_PCI
+	bool
+	select SWIOTLB
 
 config PCI_DOMAINS
 	def_bool y
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fe69286..87c13db 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -55,6 +55,7 @@ config XEN_PRIVILEGED_GUEST
 config XEN_PCI_PASSTHROUGH
        bool #"Enable support for Xen PCI passthrough devices"
        depends on XEN && PCI
+       select PCI_XEN
        help
          Enable support for passing PCI devices through to
 	 unprivileged domains. (COMPLETELY UNTESTED)
@@ -62,3 +63,4 @@ config XEN_PCI_PASSTHROUGH
 config XEN_DOM0_PCI
        def_bool y
        depends on XEN_DOM0 && PCI
+       select PCI_XEN
-- 
1.6.0.6

