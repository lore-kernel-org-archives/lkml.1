Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbYLCTwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbYLCTwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYLCTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:09 -0500
Received: from kroah.org ([198.145.64.141]:34525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754198AbYLCTuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:05 -0500
Date: Wed, 3 Dec 2008 11:48:26 -0800
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
       alan@lxorguk.ukuu.org.uk, Jay Cliburn <jcliburn@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 006/104] atl1e: fix broken multicast by removing
	unnecessary crc inversion
Message-ID: <20081203194826.GG8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1e-fix-broken-multicast-by-removing-unnecessary-crc-inversion.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: J. K. Cliburn <jcliburn@gmail.com>

commit 7ee0fddfe05f105d3346aa8774695e7130697836 upstream.

Inverting the crc after calling ether_crc_le() is unnecessary and breaks
multicast. Remove it.

Tested-by: David Madore <david.madore@ens.fr>
Signed-off-by: Jay Cliburn <jcliburn@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1e/atl1e_hw.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/atl1e/atl1e_hw.c
+++ b/drivers/net/atl1e/atl1e_hw.c
@@ -163,9 +163,6 @@ int atl1e_read_mac_addr(struct atl1e_hw 
  * atl1e_hash_mc_addr
  *  purpose
  *      set hash value for a multicast address
- *      hash calcu processing :
- *          1. calcu 32bit CRC for multicast address
- *          2. reverse crc with MSB to LSB
  */
 u32 atl1e_hash_mc_addr(struct atl1e_hw *hw, u8 *mc_addr)
 {
@@ -174,7 +171,6 @@ u32 atl1e_hash_mc_addr(struct atl1e_hw *
 	int i;
 
 	crc32 = ether_crc_le(6, mc_addr);
-	crc32 = ~crc32;
 	for (i = 0; i < 32; i++)
 		value |= (((crc32 >> i) & 1) << (31 - i));
 

