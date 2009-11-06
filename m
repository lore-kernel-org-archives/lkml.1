Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbZKFWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbZKFWXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbZKFWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:27 -0500
Received: from kroah.org ([198.145.64.141]:57069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610AbZKFWXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:49 2009
Message-Id: <20091106221548.985237484@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [74/99] pata_sc1200: Fix crash on boot
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=pata_sc1200-fix-crash-on-boot.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@linux.intel.com>

commit 6d4f950e9ea15816c6a4f266ce6b9e438346771e upstream.

The SC1200 needs a NULL terminator or it may cause a crash on boot.

Bug #14227

Also correct a bogus comment as the driver had serializing added so can run
dual port.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_sc1200.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -235,8 +235,7 @@ static int sc1200_init_one(struct pci_de
 		.udma_mask = ATA_UDMA2,
 		.port_ops = &sc1200_port_ops
 	};
-	/* Can't enable port 2 yet, see top comments */
-	const struct ata_port_info *ppi[] = { &info, };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
 }


