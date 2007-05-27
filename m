Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXE0LdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXE0LdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXE0Lc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:32:56 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33232 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXE0Lcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:32:55 -0400
Date: Sun, 27 May 2007 07:32:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd/ubi: silence gcc warning
Message-ID: <20070527113254.GA11940@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Silence the gcc warning

drivers/mtd/ubi/eba.c: In function ‘ubi_eba_read_leb’:
drivers/mtd/ubi/eba.c:371: warning: ‘crc’ may be used uninitialized in this function

This is an example of the uninit'd-var warnings emitted by gcc that
can be proven to be bogus.

Normally I would commit this to my git repository containing
such verified cases, but with all the goto-driven control flow in
ubi_eba_read_leb(), I feel that initializing the 'crc' variable is
an easy way to both shut up gcc, and also make the code less fragile
for the long term.

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 7400294..3fe1722 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -368,7 +368,7 @@ int ubi_eba_read_leb(struct ubi_device *ubi, int vol_id, int lnum, void *buf,
 	int err, pnum, scrub = 0, idx = vol_id2idx(ubi, vol_id);
 	struct ubi_vid_hdr *vid_hdr;
 	struct ubi_volume *vol = ubi->volumes[idx];
-	uint32_t crc, crc1;
+	uint32_t crc = 0, crc1;
 
 	err = leb_read_lock(ubi, vol_id, lnum);
 	if (err)
