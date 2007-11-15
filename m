Return-Path: <linux-kernel-owner+w=401wt.eu-S933486AbXKOHFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbXKOHFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbXKOGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58159 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbXKOGrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:55 -0500
Date: Wed, 14 Nov 2007 22:45:29 -0800
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
Subject: [patch 29/40] ide: Add ide_get_paired_drive() helper
Message-ID: <20071115064529.GD19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-add-ide_get_paired_drive-helper.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

patch 1b678347121001c3c230c6eccfdf9f65c3ec1a4e in mainline.

This adds a helper to get to the "other" drive on a pair connected
to a given hwif.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@osdl.org>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ide.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1437,4 +1437,11 @@ static inline int hwif_to_node(ide_hwif_
 	return dev ? pcibus_to_node(dev->bus) : -1;
 }
 
+static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif	= HWIF(drive);
+
+	return &hwif->drives[(drive->dn ^ 1) & 1];
+}
+
 #endif /* _IDE_H */

-- 
