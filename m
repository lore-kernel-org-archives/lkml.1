Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbXKOHGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbXKOHGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXKOGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58187 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764448AbXKOGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:00 -0500
Date: Wed, 14 Nov 2007 22:45:36 -0800
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
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@osdl.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 31/40] ide: Fix cs5535 driver accessing beyond array
	boundary
Message-ID: <20071115064536.GF19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-fix-cs5535-driver-accessing-beyond-array-boundary.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>


patch 15d8061bf02aa299b2447f7a22fd18b4a503ea9d in mainline.

The cs5535 uses an incorrect construct to access the other drive of a pair,
causing it to access beyond an array boundary on the secondary interface.

This fixes it by using the new ide_get_paired_drive() helper instead.

Bart: patch description fixes

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/cs5535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -84,7 +84,7 @@ static void cs5535_set_speed(ide_drive_t
 
 	/* Set the PIO timings */
 	if ((speed & XFER_MODE) == XFER_PIO) {
-		ide_drive_t *pair = &drive->hwif->drives[drive->dn ^ 1];
+		ide_drive_t *pair = ide_get_paired_drive(drive);
 		u8 cmd, pioa;
 
 		cmd = pioa = speed - XFER_PIO_0;

-- 
