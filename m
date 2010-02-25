Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab0BYRH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:07:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:54440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab0BYRHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:07:23 -0500
Date: Thu, 25 Feb 2010 17:06:38 GMT
From: "tip-bot for Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A321EE1F@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A321EE1F@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, numaq: Make CONFIG_X86_NUMAQ depend on CONFIG_PCI
Message-ID: <tip-a92d152ef9dd89c578ca2ec7118e9de8fb74a75f@git.kernel.org>
Git-Commit-ID: a92d152ef9dd89c578ca2ec7118e9de8fb74a75f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 17:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a92d152ef9dd89c578ca2ec7118e9de8fb74a75f
Gitweb:     http://git.kernel.org/tip/a92d152ef9dd89c578ca2ec7118e9de8fb74a75f
Author:     Pan, Jacob jun <jacob.jun.pan@intel.com>
AuthorDate: Wed, 24 Feb 2010 16:59:55 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 09:04:19 -0800

x86, numaq: Make CONFIG_X86_NUMAQ depend on CONFIG_PCI

The NUMAQ initialization sets x86_init.pci.init to pci_numaq_init,
which obviously isn't defined if CONFIG_PCI isn't defined.  This
dependency was implicit in the past, because pci_numaq_init was
invoked from arch/x86/pci/legacy.c, which itself was conditioned on
CONFIG_PCI.

I suspect that no NUMA-Q machines without PCI were ever built, so
instead of complicating the code by adding #ifdefs or stub functions,
just disable this bit of the configuration space.

[ hpa: rewrote the checkin comment ]

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A321EE1F@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0ab2dce..f032294 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -425,6 +425,7 @@ config X86_32_NON_STANDARD
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
 	depends on X86_32_NON_STANDARD
+	depends on PCI
 	select NUMA
 	select X86_MPPARSE
 	---help---
