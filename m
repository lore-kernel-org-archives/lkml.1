Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYGVXXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYGVXXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYGVXS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:52950 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYGVXS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:28 -0400
Date: Tue, 22 Jul 2008 16:15:11 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 15/47] b43legacy: Fix possible NULL pointer dereference in
	DMA code
Message-ID: <20080722231511.GP8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43legacy-fix-possible-null-pointer-dereference-in-dma-code.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 2f9ec47d0954f9d2e5a00209c2689cbc477a8c89 upstream

This fixes a possible NULL pointer dereference in an error path of the
DMA allocation error checking code. This is also necessary for a future
DMA API change that is on its way into the mainline kernel that adds
an additional dev parameter to dma_mapping_error().

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -876,6 +876,7 @@ struct b43legacy_dmaring *b43legacy_setu
 	if (!ring)
 		goto out;
 	ring->type = type;
+	ring->dev = dev;
 
 	nr_slots = B43legacy_RXRING_SLOTS;
 	if (for_tx)
@@ -922,7 +923,6 @@ struct b43legacy_dmaring *b43legacy_setu
 				 DMA_TO_DEVICE);
 	}
 
-	ring->dev = dev;
 	ring->nr_slots = nr_slots;
 	ring->mmio_base = b43legacy_dmacontroller_base(type, controller_index);
 	ring->index = controller_index;

-- 
