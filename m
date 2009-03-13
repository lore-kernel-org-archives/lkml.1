Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbZCMREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbZCMREg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbZCMRBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:11 -0400
Received: from gw.goop.org ([64.81.55.164]:57401 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759558AbZCMRBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/27] xen/pci: clean up Kconfig a bit
Date: Fri, 13 Mar 2009 09:59:54 -0700
Message-Id: <1236963612-14287-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cut down on the maze of PCI-related config options.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig     |    4 ++--
 arch/x86/xen/Kconfig |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9092750..653982c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1829,8 +1829,8 @@ config PCI_OLPC
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

