Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYKDX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYKDX4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYKDXk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903AbYKDXk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:57 -0500
Date: Tue, 4 Nov 2008 15:33:23 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 50/57] libata: Fix LBA48 on pata_it821x RAID volumes.
Message-ID: <20081104233323.GY659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-fix-lba48-on-pata_it821x-raid-volumes.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ondrej Zary <linux@rainbow-software.org>

Subject: [patch 50/57] libata: Fix LBA48 on pata_it821x RAID volumes.

commit 054e5f616b5becdc096b793407dc33fe379749ac upstream

libata: Fix LBA48 on pata_it821x RAID volumes.

[http://lkml.org/lkml/2008/10/18/82]

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_it821x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -557,9 +557,8 @@ static unsigned int it821x_read_id(struc
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* Set feature bits the firmware neglects */
 		id[49] |= 0x0300;	/* LBA, DMA */
-		id[82] |= 0x0400;	/* LBA48 */
 		id[83] &= 0x7FFF;
-		id[83] |= 0x4000;	/* Word 83 is valid */
+		id[83] |= 0x4400;	/* Word 83 is valid and LBA48 */
 		id[86] |= 0x0400;	/* LBA48 on */
 		id[ATA_ID_MAJOR_VER] |= 0x1F;
 	}

-- 
