Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZFSFBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZFSFBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZFSFBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:01:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50036 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZFSFBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:01:11 -0400
Date: Fri, 19 Jun 2009 07:01:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, dedekind1@gmail.com, fweisbec@gmail.com
Subject: Re: [PATCH 0/15] Per-bdi writeback flusher threads v10
Message-ID: <20090619050113.GD11363@kernel.dk>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com> <1245114397.2560.368.camel@ymzhang> <20090616080036.GO11363@kernel.dk> <20090616195329.GH11363@kernel.dk> <1245286866.2560.407.camel@ymzhang> <20090618051338.GH11363@kernel.dk> <1245302369.2560.410.camel@ymzhang> <20090618123503.GV11363@kernel.dk> <1245386680.2560.416.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245386680.2560.416.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19 2009, Zhang, Yanmin wrote:
> > > > Sorry I should have made that more clear when posting v11. This patch
> > > > wont fully solve the problem, however the v11 patch series should. So if
> > > > you test with that, hopefully all soft hangs should be gone.
> > > Ok. I will start new testing against V11. I also add some debugging codes into
> > > V11.
> > 
> > Great, thanks! There's a small issue with v11 that you should be aware
> > of. The test for bdi_add_default_flusher_task() was inverted. I'm
> > attaching a diff at the end. The interesting bit is the 2nd hunk of
> > backing-dev.c, the others are just a cleanup.
> Jens,
> 
> I did entensive testing with fio (especially the aio randread which triggers
> the hang)/ffsb and a couple of other testing and didn't hit the hang issue.
> So V11 does fix the issue.

Great!

> From performance point of view, there is no big difference than old versions.

That's fine too, it's only been bug fixes the last few revisions. I'll
tag a v12 with the small fix.

-- 
Jens Axboe

