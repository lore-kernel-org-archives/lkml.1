Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYFSVdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYFSVdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYFSVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:42714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbYFSVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:05 -0400
Date: Thu, 19 Jun 2008 14:29:56 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
       bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 07/15] b43: Fix possible NULL pointer dereference in DMA
	code
Message-ID: <20080619212956.GH20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-possible-null-pointer-dereference-in-dma-code.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

a cut-down version of commit 028118a5f09a9c807e6b43e2231efdff9f224c74 upstream

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code. In case the DMA allocation address is invalid,
the dev pointer is dereferenced for unmapping of the buffer.

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -850,6 +850,7 @@ struct b43_dmaring *b43_setup_dmaring(st
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43_RXRING_SLOTS;
 	if (for_tx)
@@ -901,7 +902,6 @@ struct b43_dmaring *b43_setup_dmaring(st
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;

-- 
