Return-Path: <linux-kernel-owner+w=401wt.eu-S1750980AbXBLAQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbXBLAQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXBLAQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:16:14 -0500
Received: from ns.suse.de ([195.135.220.2]:42130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbXBLAQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:16:13 -0500
From: Neil Brown <neilb@suse.de>
To: "Marc Marais" <marcm@liquid-nexus.net>
Date: Mon, 12 Feb 2007 11:15:38 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17871.45482.186152.158022@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: md: md6_raid5 crash 2.6.20
In-Reply-To: message from Marc Marais on Monday February 12
References: <20070211071527.M31642@liquid-nexus.net>
	<17871.37497.786198.834303@notabene.brown>
	<20070212000042.M73586@liquid-nexus.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday February 12, marcm@liquid-nexus.net wrote:
> 
> Thanks for the quick response Neil unfortunately the kernel doesn't build with
> this patch due to a missing symbol:
> 
> WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!
> 
> Is that in another file that needs patching or within raid5.c?

Yes.  I keep forgetting about that bit. Sorry.


diff -puN block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix
+++ a/block/ll_rw_blk.c
@@ -1264,7 +1264,7 @@ new_hw_segment:
 	bio->bi_hw_segments = nr_hw_segs;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
-
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
_
