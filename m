Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbYJGBDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbYJGBDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYJGAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:32829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbYJGAqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:22 -0400
Date: Mon, 6 Oct 2008 17:40:15 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 64/71] sparc64: Fix missing devices due to PCI bridge test
	in of_create_pci_dev().
Message-ID: <20081007004015.GM3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-sparc64-Fix-missing-devices-due-to-PCI-bridge-test.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 44b50e5a1af13c605d6c3b17a60e42eb0ee48d5f ]

Just like in the arch/sparc64/kernel/of_device.c code fix commit
071d7f4c3b411beae08d27656e958070c43b78b4 ("sparc64: Fix disappearing
PCI devices on e3500.") we have to check the OF device node name for
"pci" instead of relying upon the 'device_type' property being there
on all PCI bridges.

Tested by Meelis Roos, and confirmed to make the PCI QFE devices
reappear on the E3500 system.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -425,7 +425,7 @@ struct pci_dev *of_create_pci_dev(struct
 	dev->current_state = 4;		/* unknown power state */
 	dev->error_state = pci_channel_io_normal;
 
-	if (!strcmp(type, "pci") || !strcmp(type, "pciex")) {
+	if (!strcmp(node->name, "pci")) {
 		/* a PCI-PCI bridge */
 		dev->hdr_type = PCI_HEADER_TYPE_BRIDGE;
 		dev->rom_base_reg = PCI_ROM_ADDRESS1;

-- 
