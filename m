Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbYHRTNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbYHRTNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763289AbYHRTIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:08:46 -0400
Received: from mail.suse.de ([195.135.220.2]:44652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763282AbYHRTIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:08:45 -0400
Date: Mon, 18 Aug 2008 11:45:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Dean Hildebrand <dhildeb@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 59/60] PCI: Limit VPD length for Broadcom 5708S
Message-ID: <20080818184545.GH29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-limit-vpd-length-for-broadcom-5708s.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dean Hildebrand <seattleplus@gmail.com>

commit 35405f256de924be56ea5edaca4cdc627f1bb0f8 upstream

BCM5706S wont work correctly unless VPD length truncated to 128

Signed-off-by: Dean Hildebrand <dhildeb@us.ibm.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1683,9 +1683,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VI
  */
 static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
 {
-	/*  Only disable the VPD capability for 5706, 5708, and 5709 rev. A */
+	/*
+	 * Only disable the VPD capability for 5706, 5706S, 5708,
+	 * 5708S and 5709 rev. A
+	 */
 	if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
+	    (dev->device == PCI_DEVICE_ID_NX2_5706S) ||
 	    (dev->device == PCI_DEVICE_ID_NX2_5708) ||
+  	    (dev->device == PCI_DEVICE_ID_NX2_5708S) ||
 	    ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
 	     (dev->revision & 0xf0) == 0x0)) {
 		if (dev->vpd)

-- 
