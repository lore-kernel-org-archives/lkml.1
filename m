Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYKLAic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYKLAic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYKLA0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:44 -0500
Received: from kroah.org ([198.145.64.141]:42499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbYKLA0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:43 -0500
Date: Tue, 11 Nov 2008 16:24:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Tomas Winkler <tomas.winkler@intel.com>,
       Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 32/49] iwlwifi: use correct DMA_MASK
Message-ID: <20081112002400.GG10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-use-correct-dma_mask.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 093d874c02e8d3091aa38596faf0ff2bfd4f0ceb upstream

Use correct DMA_MASK: 4964 and 5000 support 36 bit addresses for
pci express memory access.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4225,13 +4225,13 @@ static int iwl4965_pci_probe(struct pci_
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(36));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(36));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (!err)
-			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
 			printk(KERN_WARNING "%s: No suitable DMA available.\n",

-- 
