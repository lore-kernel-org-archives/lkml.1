Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab0BXTIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:08:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:36865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab0BXTIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:08:11 -0500
Date: Wed, 24 Feb 2010 19:04:49 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A321E8F7@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A321E8F7@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, pci: Add sanity check for PCI fixed bar probing
Message-ID: <tip-c54113823c777f035fa7444f8841fbccda4a5cc0@git.kernel.org>
Git-Commit-ID: c54113823c777f035fa7444f8841fbccda4a5cc0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 19:04:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c54113823c777f035fa7444f8841fbccda4a5cc0
Gitweb:     http://git.kernel.org/tip/c54113823c777f035fa7444f8841fbccda4a5cc0
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Wed, 24 Feb 2010 09:42:50 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 24 Feb 2010 11:01:34 -0800

x86, pci: Add sanity check for PCI fixed bar probing

While probing for the PCI fixed BAR capability in the extended PCI
configuration space we need to make sure raw_pci_ext_ops is
actually initialized.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A321E8F7@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/pci/mrst.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 6e9e1a3..8bf2fcb 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -57,6 +57,10 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
 	u32 pcie_cap = 0, cap_data;
 
 	pos = PCIE_CAP_OFFSET;
+
+	if (!raw_pci_ext_ops)
+		return 0;
+
 	while (pos) {
 		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
 					  devfn, pos, 4, &pcie_cap))
