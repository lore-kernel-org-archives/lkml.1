Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbYD2RaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbYD2RaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbYD2RVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:36 -0400
Received: from ns.suse.de ([195.135.220.2]:52282 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062AbYD2RVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:35 -0400
Date: Tue, 29 Apr 2008 10:18:53 -0700
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
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [24/37] b43: Add more btcoexist workarounds
Message-ID: <20080429171853.GY14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-add-more-btcoexist-workarounds.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 9fc38458355525f801cd2ab403ac89850489a05e upstream

This adds more workarounds for devices with broken BT bits.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4009,6 +4009,12 @@ static int b43_one_core_attach(struct ss
 	return err;
 }
 
+#define IS_PDEV(pdev, _vendor, _device, _subvendor, _subdevice)		( \
+	(pdev->vendor == PCI_VENDOR_ID_##_vendor) &&			\
+	(pdev->device == _device) &&					\
+	(pdev->subsystem_vendor == PCI_VENDOR_ID_##_subvendor) &&	\
+	(pdev->subsystem_device == _subdevice)				)
+
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
 	struct pci_dev *pdev;
@@ -4022,10 +4028,9 @@ static void b43_sprom_fixup(struct ssb_b
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
 		pdev = bus->host_pci;
-		if (pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
-		    pdev->device == 0x4318 &&
-		    pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK &&
-		    pdev->subsystem_device == 0x100F)
+		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
 			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
 	}
 }

-- 
