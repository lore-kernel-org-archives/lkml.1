Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbXKOHCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbXKOHCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932557AbXKOGrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763580AbXKOGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:39 -0500
Date: Wed, 14 Nov 2007 22:45:10 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>, Marcel Holtmann <marcel@holtmann.org>
Subject: [patch 23/40] USB: add URB_FREE_BUFFER to permissible flags
Message-ID: <20071115064510.GX19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-add-urb_free_buffer-to-permissible-flags.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

patch 0b28baaf74ca04be2e0cc4d4dd2bbc801697f744 in mainline.

URB_FREE_BUFFER needs to be allowed in the sanity checks to use drivers that
use that flag.


Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/urb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -358,7 +358,7 @@ int usb_submit_urb(struct urb *urb, gfp_
 
 	/* enforce simple/standard policy */
 	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_SETUP_DMA_MAP |
-			URB_NO_INTERRUPT);
+			URB_NO_INTERRUPT | URB_FREE_BUFFER);
 	switch (temp) {
 	case PIPE_BULK:
 		if (is_out)

-- 
