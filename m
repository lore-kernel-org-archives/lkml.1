Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbZE0H0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbZE0H0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbZE0HZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:25:19 -0400
Received: from claw.goop.org ([74.207.240.146]:33593 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762112AbZE0HZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:25:17 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/10] xen/pci: clean up Kconfig a bit
Date: Wed, 27 May 2009 00:24:41 -0700
Message-Id: <1243409082-21349-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cut down on the maze of PCI-related config options.

[ Impact: Kconfig cleanup ]

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

