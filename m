Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYL3E1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYL3E1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 23:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYL3E0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 23:26:53 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1951 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYL3E0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 23:26:52 -0500
Date: Mon, 29 Dec 2008 23:26:30 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081230042630.GA13664@hash.localnet>
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <1229174904.4964.5.camel@maxim-laptop> <20081213142444.GA19852@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213142444.GA19852@hash.localnet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 09:24:45AM -0500, Bob Copeland wrote:
> > Indeed gpio #3 controls the led.
> > I patched ath5k to use it, and led works now fine.

Sorry for the delay, can you test this patch?

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 29 Dec 2008 23:14:24 -0500
Subject: [PATCH] ath5k: support LEDs on aspire one laptop

Add vendor ID for Foxconn and use it to set the ath5k LED gpio and
polarity for Acer branded laptops.

base.c:
Changes-licensed-under: 3-Clause-BSD

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    7 +++++++
 include/linux/pci_ids.h           |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 40c0155..eb0675f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2595,6 +2595,13 @@ ath5k_init_leds(struct ath5k_softc *sc)
 		sc->led_pin = 1;
 		sc->led_on = 1;  /* active high */
 	}
+	/* Pin 3 on Foxconn chips used in Aspire One A150 (0x105b:e008) */
+	if (pdev->subsystem_vendor == PCI_VENDOR_ID_FOXCONN) {
+		__set_bit(ATH_STAT_LEDSOFT, sc->status);
+		sc->led_pin = 3;
+		sc->led_on = 1;  /* active high */
+	}
+
 	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
 		goto out;
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1800f1d..c1fb01c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -834,6 +834,8 @@
 #define PCI_DEVICE_ID_PROMISE_20276	0x5275
 #define PCI_DEVICE_ID_PROMISE_20277	0x7275
 
+#define PCI_VENDOR_ID_FOXCONN		0x105b
+
 #define PCI_VENDOR_ID_UMC		0x1060
 #define PCI_DEVICE_ID_UMC_UM8673F	0x0101
 #define PCI_DEVICE_ID_UMC_UM8886BF	0x673a
-- 
1.6.0.4


-- 
Bob Copeland %% www.bobcopeland.com

