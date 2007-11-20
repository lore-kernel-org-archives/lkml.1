Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbXKTSaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbXKTSaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbXKTS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60268 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761503AbXKTS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:36 -0500
Date: Tue, 20 Nov 2007 10:23:52 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jgarzik@redhat.com>, Tobias Powalowski <t.powa@gmx.de>
Subject: [patch 13/29] libata: sata_sis: use correct S/G table size
Message-ID: <20071120182352.GN28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-sata_sis-use-correct-s-g-table-size.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jeff Garzik <jeff@garzik.org>

patch 96af154710d44b574515431a0bb014888398a741 in mainline.

[libata] sata_sis: use correct S/G table size

sata_sis has the same restrictions as other SFF controllers, and so must
use LIBATA_MAX_PRD to denote that SCSI may only fill ATA_MAX_PRD/2
entries, due to our need to handle IOMMU merging.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Tobias Powalowski <t.powa@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_sis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -92,7 +92,7 @@ static struct scsi_host_template sis_sht
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= ATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,

-- 
