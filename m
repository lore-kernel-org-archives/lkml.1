Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXEIKcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXEIKcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbXEIKc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:32:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:25024 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbXEIKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:32:24 -0400
Date: Wed, 9 May 2007 12:29:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, Rene Herman <rene.herman@gmail.com>
Subject: Re: [patch 8/9] lguest: the block driver
Message-ID: <20070509102933.GR4163@kernel.dk>
References: <200705090951.l499pdsc020409@shell0.pdx.osdl.net> <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Pekka Enberg wrote:
> On 5/9/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> >+/* Jens gave me this nice helper to end all chunks of a request. */
> >+static void end_entire_request(struct request *req, int uptodate)
> >+{
> >+       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> >+               BUG();
> >+       add_disk_randomness(req->rq_disk);
> >+       blkdev_dequeue_request(req);
> >+       end_that_request_last(req, uptodate);
> >+}
> 
> Again, I would prefer this went straight into block/ll_rw_blk.c. Rene
> and I am using something similar in the new Mitsumi driver although
> one of us has a bug already, we're using req->nr_sectors for this...

Lets do it after it is merged, as not to create a hold-up point for
lguest. Once it's in, I'll fix it up.

-- 
Jens Axboe

