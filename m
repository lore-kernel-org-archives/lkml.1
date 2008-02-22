Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbYBVVnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbYBVVnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbYBVVm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:42:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:46332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761423AbYBVVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:42:53 -0500
Date: Fri, 22 Feb 2008 13:40:06 -0800
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
       Jeff Garzik <jeff@garzik.org>, Mikael Pettersson <mikpe@it.uu.se>
Subject: [patch 02/23] sata_promise: FastTrack TX4200 is a
	second-generation chip
Message-ID: <20080222214006.GC8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_promise-fasttrack-tx4200-is-a-second-generation-chip.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

patch 7f9992a23190418592f0810900e4f91546ec41da in mainline.

This patch corrects sata_promise to classify FastTrack TX4200
(DID 3515/3519) as a second-generation chip. Promise's partial-
source FT TX4200 driver confirms this classification.

Treating it as a first-generation chip causes several problems:
1. Detection failures. This is a recent regression triggered by
   the hotplug-enabling changes in 2.6.23-rc1.
2. Various "failed to resume link for reset" warnings.

This patch fixes <http://bugzilla.kernel.org/show_bug.cgi?id=8936>.

Thanks to Stephen Ziemba for reporting the bug and for testing the fix.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_promise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -330,8 +330,8 @@ static const struct pci_device_id pdc_at
 
 	{ PCI_VDEVICE(PROMISE, 0x3318), board_20319 },
 	{ PCI_VDEVICE(PROMISE, 0x3319), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3515), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3519), board_20319 },
+	{ PCI_VDEVICE(PROMISE, 0x3515), board_40518 },
+	{ PCI_VDEVICE(PROMISE, 0x3519), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d17), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d18), board_40518 },
 

-- 
