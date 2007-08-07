Return-Path: <linux-kernel-owner+w=401wt.eu-S937159AbXHGVXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937159AbXHGVXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965082AbXHGU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072AbXHGU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:10 -0400
Date: Tue, 7 Aug 2007 13:48:32 -0700
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
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [2.6.22.2 review 68/84] ieee1394: revert "sbp2: enforce 32bit DMA
	mapping"
Message-ID: <20070807204832.GR23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ieee1394-revert-sbp2-enforce-32bit-dma-mapping.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
http://lkml.org/lkml/2007/8/1/344

Should there ever occur a DMA mapping beyond the physical DMA range, a
proper SBP-2 firmware will report transport errors.  So let's leave it
at that.

Same as commit a9c2f18800753c82c45fc13b27bdc148849bdbb2.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Tested-by: Olaf Hering <olh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/sbp2.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -774,11 +774,6 @@ static struct sbp2_lu *sbp2_alloc_device
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
-#else
-		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
-			SBP2_ERR("failed to set 4GB DMA mask");
-			goto failed_alloc;
-		}
 #endif
 	}
 

-- 
