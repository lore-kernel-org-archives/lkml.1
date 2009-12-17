Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZLQBUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZLQBUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763574AbZLQBTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:19:52 -0500
Received: from kroah.org ([198.145.64.141]:47746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763546AbZLQBTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.346236779@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [04/90] ALSA: hda - Terradici HDA controllers does not support 64-bit mode
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit 396087eaead95fcb29eb36f1e59517aeb58c545e upstream.

Confirmed from vendor and tests in RedHat bugzilla #536782 .

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2392,6 +2392,11 @@ static int __devinit azx_create(struct s
 		}
 	}
 
+	/* disable 64bit DMA address for Teradici */
+	/* it does not work with device 6549:1200 subsys e4a2:040b */
+	if (chip->driver_type == AZX_DRIVER_TERA)
+		gcap &= ~ICH6_GCAP_64OK;
+
 	/* allow 64bit DMA address if supported by H/W */
 	if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
 		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));


