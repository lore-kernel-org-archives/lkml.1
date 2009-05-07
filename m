Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbZEHAai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbZEHAai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759735AbZEHAKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:50 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52709
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756018AbZEHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/11] xen/pci: clean up Kconfig a bit
Date: Thu,  7 May 2009 14:45:36 -0700
Message-Id: <1241732737-7669-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Cut down on the maze of PCI-related config options.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig     |    4 ++--
 arch/x86/xen/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4a62659..8f28d3e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1831,8 +1831,8 @@ config PCI_OLPC
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

