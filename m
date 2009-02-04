Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZBDSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZBDSic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbZBDShB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:01 -0500
Received: from kroah.org ([198.145.64.141]:50919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755040AbZBDSg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:36:59 -0500
Date: Wed, 4 Feb 2009 10:34:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Mark Lord <mlord@pobox.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 03/33] sata_mv: fix 8-port timeouts on 508x/6081 chips
Message-ID: <20090204183420.GD13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_mv-fix-8-port-timeouts-on-508x-6081-chips.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Lord <liml@rtr.ca>

commit b0bccb18bc523d1d5060d25958f12438062829a9 upstream.

Fix a longstanding bug for the 8-port Marvell Sata controllers (508x/6081),
where accesses to the upper 4 ports would cause lost-interrupts / timeouts
for the lower 4-ports.  With this patch, the 6081 boards should finally be
reliable enough for mainstream use with Linux.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_mv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -883,7 +883,7 @@ static void mv_start_dma(struct ata_port
 		struct mv_host_priv *hpriv = ap->host->private_data;
 		int hardport = mv_hardport_from_port(ap->port_no);
 		void __iomem *hc_mmio = mv_hc_base_from_port(
-					mv_host_base(ap->host), hardport);
+					mv_host_base(ap->host), ap->port_no);
 		u32 hc_irq_cause, ipending;
 
 		/* clear EDMA event indicators, if any */

