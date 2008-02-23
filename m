Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYBWAvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYBWAvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764903AbYBWAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:36:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:45060 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764496AbYBWAg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:36:26 -0500
Date: Fri, 22 Feb 2008 16:31:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>, Olaf Hering <olaf@aepfle.de>
Subject: [patch 36/38] POWERPC: Revert chrp_pci_fixup_vt8231_ata devinit to
	fix libata on pegasos
Message-ID: <20080223003137.GK7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-revert-chrp_pci_fixup_vt8231_ata-devinit-to-fix-libata-on-pegasos.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Olaf Hering <olaf@aepfle.de>

Commit: 092ca5bd61da6344f3b249754b337f2d48dfe08d

[POWERPC] Revert chrp_pci_fixup_vt8231_ata devinit to fix libata on pegasos

Commit 6d98bda79bea0e1be26c0767d0e9923ad3b72f2e changed the init order
for chrp_pci_fixup_vt8231_ata().

It can not work anymore because either the irq is not yet set to 14 or
pci_get_device() returns nothing.  At least the printk() in
chrp_pci_fixup_vt8231_ata() does not trigger anymore.
pata_via works again on Pegasos with the change below.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/chrp/pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -354,7 +354,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_WI
  * mode as well. The same fixup must be done to the class-code property in
  * the IDE node /pci@80000000/ide@C,1
  */
-static void __devinit chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
+static void chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
 {
 	u8 progif;
 	struct pci_dev *viaisa;
@@ -375,4 +375,4 @@ static void __devinit chrp_pci_fixup_vt8
 
 	pci_dev_put(viaisa);
 }
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, chrp_pci_fixup_vt8231_ata);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1, chrp_pci_fixup_vt8231_ata);

-- 
