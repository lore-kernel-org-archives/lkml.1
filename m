Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXKSS27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXKSS27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXKSSWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49363 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbXKSSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:40 -0500
Date: Mon, 19 Nov 2007 10:19:28 -0800
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
       Tony Battersby <tonyb@cybernetics.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 22/26] ide: fix serverworks.c UDMA regression
Message-ID: <20071119181928.GW15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-fix-serverworks.c-udma-regression.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Tony Battersby <tonyb@cybernetics.com>

patch 0c824b51b338c808de650b440ba5f9f4a725f7fc in mainline.

The patch described by the following excerpt from ChangeLog-2.6.22 makes
it impossible to use UDMA on a Tyan S2707 motherboard (SvrWks CSB5):

commit 2d5eaa6dd744a641e75503232a01f52d0768884c
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Thu May 10 00:01:08 2007 +0200

    ide: rework the code for selecting the best DMA transfer mode (v3)

    ...

This one-line patch against 2.6.23 fixes the problem.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/serverworks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -101,6 +101,7 @@ static u8 svwks_udma_filter(ide_drive_t 
 			mode = 2;
 
 		switch(mode) {
+		case 3:	 mask = 0x3f; break;
 		case 2:	 mask = 0x1f; break;
 		case 1:	 mask = 0x07; break;
 		default: mask = 0x00; break;

-- 
