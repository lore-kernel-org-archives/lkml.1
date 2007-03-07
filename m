Return-Path: <linux-kernel-owner+w=401wt.eu-S1422858AbXCGSA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858AbXCGSA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422756AbXCGSAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:00:31 -0500
Received: from ns2.suse.de ([195.135.220.15]:42674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422759AbXCGRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:31 -0500
Message-Id: <20070307171133.656578650@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Tejun Heo <htejun@gmail.com>
Subject: [patch 005/101] pata_amd: fix an obvious bug in cable detection
Content-Disposition: inline; filename=pata_amd-fix-an-obvious-bug-in-cable-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


80c test mask is at bits 18 and 19 of EIDE Controller Configuration
not 22 and 23.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/ata/pata_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/ata/pata_amd.c
+++ linux-2.6.20.1/drivers/ata/pata_amd.c
@@ -128,7 +128,7 @@ static void timing_setup(struct ata_port
 
 static int amd_pre_reset(struct ata_port *ap)
 {
-	static const u32 bitmask[2] = {0x03, 0xC0};
+	static const u32 bitmask[2] = {0x03, 0x0C};
 	static const struct pci_bits amd_enable_bits[] = {
 		{ 0x40, 1, 0x02, 0x02 },
 		{ 0x40, 1, 0x01, 0x01 }
@@ -247,7 +247,7 @@ static void amd133_set_dmamode(struct at
  */
 
 static int nv_pre_reset(struct ata_port *ap) {
-	static const u8 bitmask[2] = {0x03, 0xC0};
+	static const u8 bitmask[2] = {0x03, 0x0C};
 	static const struct pci_bits nv_enable_bits[] = {
 		{ 0x50, 1, 0x02, 0x02 },
 		{ 0x50, 1, 0x01, 0x01 }

--
