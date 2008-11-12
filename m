Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYKLAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYKLAgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYKLA0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:38 -0500
Received: from kroah.org ([198.145.64.141]:42397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753605AbYKLA0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:35 -0500
Date: Tue, 11 Nov 2008 16:23:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 26/49] I/OAT: fix async_tx.callback checking
Message-ID: <20081112002347.GA10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i-oat-fix-async_tx.callback-checking.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

commit 12ccea24e309d815d058cdc6ee8bf2c4b85f0c5f upstream

async_tx.callback should be checked for the first
not the last descriptor in the chain.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -519,7 +519,7 @@ static dma_cookie_t ioat1_tx_submit(stru
 	}
 
 	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	if (new->async_tx.callback) {
+	if (first->async_tx.callback) {
 		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
 		if (first != new) {
 			/* move callback into to last desc */
@@ -611,7 +611,7 @@ static dma_cookie_t ioat2_tx_submit(stru
 	}
 
 	hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	if (new->async_tx.callback) {
+	if (first->async_tx.callback) {
 		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
 		if (first != new) {
 			/* move callback into to last desc */

-- 
