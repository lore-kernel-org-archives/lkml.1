Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbYEMUXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbYEMUXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbYEMUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbYEMUQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:15 -0400
Date: Tue, 13 May 2008 13:12:38 -0700
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
       Roel Kluin <12o3l@tiscali.nl>, Francois Romieu <romieu@fr.zoreil.com>
Subject: [patch 29/37] r8169: fix past rtl_chip_info array size for unknown
	chipsets
Message-ID: <20080513201238.GD31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-fix-past-rtl_chip_info-array-size-for-unknown-chipsets.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Roel Kluin <12o3l@tiscali.nl>

commit cee60c377de6d9d10f0a2876794149bd79a15020 upstream.

'i' is unsigned.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1705,18 +1705,18 @@ rtl8169_init_one(struct pci_dev *pdev, c
 
 	rtl8169_print_mac_version(tp);
 
-	for (i = ARRAY_SIZE(rtl_chip_info) - 1; i >= 0; i--) {
+	for (i = 0; i < ARRAY_SIZE(rtl_chip_info); i++) {
 		if (tp->mac_version == rtl_chip_info[i].mac_version)
 			break;
 	}
-	if (i < 0) {
+	if (i == ARRAY_SIZE(rtl_chip_info)) {
 		/* Unknown chip: assume array element #0, original RTL-8169 */
 		if (netif_msg_probe(tp)) {
 			dev_printk(KERN_DEBUG, &pdev->dev,
 				"unknown chip version, assuming %s\n",
 				rtl_chip_info[0].name);
 		}
-		i++;
+		i = 0;
 	}
 	tp->chipset = i;
 

-- 
