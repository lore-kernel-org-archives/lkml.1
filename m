Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYGaAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYGaAaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYGaA10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:27:26 -0400
Received: from mail.suse.de ([195.135.220.2]:39914 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763629AbYGaA1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:27:24 -0400
Date: Wed, 30 Jul 2008 17:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Pavel Roskin <proski@gnu.org>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 61/62] ath5k: dont enable MSI, we cannot handle it yet
Message-ID: <20080731000020.GI12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-don-t-enable-msi-we-cannot-handle-it-yet.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Pavel Roskin <proski@gnu.org>

commit 256b152b005e319f985f50f2a910a75ba0def74f upstream

MSI is a nice thing, but we cannot enable it without changing the
interrupt handler.  If we do it, we break MSI capable hardware,
specifically AR5006 chipset.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -487,9 +487,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	/* Set private data */
 	pci_set_drvdata(pdev, hw);
 
-	/* Enable msi for devices that support it */
-	pci_enable_msi(pdev);
-
 	/* Setup interrupt handler */
 	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (ret) {
@@ -567,7 +564,6 @@ err_ah:
 err_irq:
 	free_irq(pdev->irq, sc);
 err_free:
-	pci_disable_msi(pdev);
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
@@ -589,7 +585,6 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	ath5k_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
 	free_irq(pdev->irq, sc);
-	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);

-- 
