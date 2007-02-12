Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXBLIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXBLIvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933126AbXBLIvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:51:31 -0500
Received: from smtp.ono.com ([62.42.230.12]:42423 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933125AbXBLIva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:51:30 -0500
Date: Mon, 12 Feb 2007 09:51:27 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at
 mm/filemap.c:537!
Message-ID: <20070212095127.7ec4b22d@werewolf-wl>
In-Reply-To: <17865.3776.511594.763544@notabene.brown>
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
	<17865.3776.511594.763544@notabene.brown>
X-Mailer: Claws Mail 2.7.2cvs38 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 10:26:56 +1100, Neil Brown <neilb@suse.de> wrote:

> On Tuesday February 6, neilb@suse.de wrote:
> > 
> > This patch should fix the worst of the offences, but I'd like to
> > experiment and think a bit more before I submit it to stable.
> > And probably test it too - as yet I have only compile and brain
> > tested.
> 
> Ok, I've experimented and tested and now I know what was causing the
> double-unlock.
> 
> The following patch is suitable for 2.6.20.1 and mainline.  There is
> room for a bit more improvement, but only for performance, not
> correctness.  I'll look into that later.
> 

> +	blk_recount_segments(q, bi);

I needed to export blk_recount_segments() to build raid as a module:

--- linux/block/ll_rw_blk.c.orig	2007-02-12 09:46:55.000000000 +0100
+++ linux/block/ll_rw_blk.c	2007-02-12 09:45:57.000000000 +0100
@@ -1258,6 +1258,8 @@
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
 
+EXPORT_SYMBOL(blk_recount_segments);
+
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
 {

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam06 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
