Return-Path: <linux-kernel-owner+w=401wt.eu-S1751058AbXBUBom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbXBUBom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXBUBja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:39:30 -0500
Received: from ns.suse.de ([195.135.220.2]:42285 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXBUBjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:10 -0500
Date: Tue, 20 Feb 2007 17:37:48 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: [patch 11/21] pata_amd: fix an obvious bug in cable detection
Message-ID: <20070221013748.GL30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pata_amd-fix-an-obvious-bug-in-cable-detection.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

80c test mask is at bits 18 and 19 of EIDE Controller Configuration
not 22 and 23.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/ata/pata_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.4.orig/drivers/ata/pata_amd.c
+++ linux-2.6.19.4/drivers/ata/pata_amd.c
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
