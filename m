Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbZBNBTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbZBNBTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZBNBCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:02:22 -0500
Received: from kroah.org ([198.145.64.141]:40001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761566AbZBNBCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:02:08 -0500
Date: Fri, 13 Feb 2009 16:59:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 45/47] x86: fixup config space size of CPU functions for
	AMD family 11h
Message-ID: <20090214005931.GT11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fixup-config-space-size-of-cpu-functions-for-amd-family-11h.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit ffd565a8b817d1eb4b25184e8418e8d96c3f56f6 upstream.

Impact: extend allowed configuration space access on 11h CPUs from 256 to 4K

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/pci/fixup.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -496,18 +496,21 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 			  pci_siemens_interrupt_controller);
 
 /*
- * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
- * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
- * access it.  Maybe we don't have a way to generate extended config space
- * accesses.   So check it
+ * Regular PCI devices have 256 bytes, but AMD Family 10h/11h CPUs have
+ * 4096 bytes configuration space for each function of their processor
+ * configuration space.
  */
-static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+static void amd_cpu_pci_cfg_space_size(struct pci_dev *dev)
 {
 	dev->cfg_size = pci_cfg_space_size_ext(dev);
 }
-
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1300, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1301, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1302, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1303, amd_cpu_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1304, amd_cpu_pci_cfg_space_size);

