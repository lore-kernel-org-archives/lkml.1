Return-Path: <linux-kernel-owner+w=401wt.eu-S941132AbXGaC0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941132AbXGaC0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939970AbXGaCSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940532AbXGaCSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:01 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:48 +1000
Message-Id: <1070731021748.25445@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 023 of 35] Teach pktcdvd.c to honour bi_offset and bi_size
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/block/pktcdvd.c ./drivers/block/pktcdvd.c
--- .prev/drivers/block/pktcdvd.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/block/pktcdvd.c	2007-07-31 11:21:13.000000000 +1000
@@ -1391,7 +1391,7 @@ static void pkt_start_write(struct pktcd
 	spin_lock(&pkt->lock);
 	for (bio = pkt->orig_bios; bio; bio = bio->bi_next) {
 		int segment = 0;
-		int src_offs = 0;
+		int src_offs = bio->bi_offset;
 		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
 		int num_frames = bio->bi_size / CD_FRAMESIZE;
 		BUG_ON(first_frame < 0);
