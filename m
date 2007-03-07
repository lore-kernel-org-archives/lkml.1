Return-Path: <linux-kernel-owner+w=401wt.eu-S1422876AbXCGRcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422876AbXCGRcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422850AbXCGRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422876AbXCGRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:04 -0500
Message-Id: <20070307171525.905650351@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>
Subject: [patch 072/101] export blk_recount_segments
Content-Disposition: inline; filename=md_md5_6_bio_too_big_fix_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 12, marcm@liquid-nexus.net wrote:
> > 
> > Thanks for the quick response Neil unfortunately the kernel doesn't build with
> > this patch due to a missing symbol:
> > 
> > WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!
> > 
> > Is that in another file that needs patching or within raid5.c?

Yes.  I keep forgetting about that bit. Sorry.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/ll_rw_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/block/ll_rw_blk.c
+++ linux-2.6.20.1/block/ll_rw_blk.c
@@ -1264,7 +1264,7 @@ new_hw_segment:
 	bio->bi_hw_segments = nr_hw_segs;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
-
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)

--
