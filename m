Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbXIUFSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbXIUFSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 01:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXIUFSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 01:18:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXIUFSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 01:18:37 -0400
Date: Fri, 21 Sep 2007 07:19:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH] pktcdvd: don't rely on bio_init() preserving
	bio->bi_destructor
Message-ID: <20070921051924.GP2367@kernel.dk>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46E5A6D1.3050704@free.fr> <46E9BEB1.3060504@free.fr> <20070914093358.GB25592@kernel.dk> <20070914110606.GJ25592@kernel.dk> <46EADB35.7000309@free.fr> <46F2E54C.3070504@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46F2E54C.3070504@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20 2007, Laurent Riffard wrote:
> Le 14.09.2007 21:04, Laurent Riffard a écrit :
> > Le 14.09.2007 13:06, Jens Axboe a écrit :
> >> On Fri, Sep 14 2007, Jens Axboe wrote:
> >>> On Fri, Sep 14 2007, Laurent Riffard wrote:
> >>>> Le 10.09.2007 22:19, Laurent Riffard a écrit :
> >>>>> Jens,
> >>>>>
> >>>>> git-block.patch broke pktcdvd, I've got an Oops while syncing:
> >>>>>
> > [snip]
> >>>> I dig through git-block.patch and the culprit seems to be commit
> >>>> c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
> >>>> bio_init()".
> >>>>
> >>>> Maybe the real bug is a bad bio initialization in pktcdvd driver,
> >>>> which is revealed by this commit ?
> >>> At least pktcdvd doesn't expect bio->bi_io_vec[] to be cleared, that's
> >>> why it's oopsing now. I'll revert this bit for now, thanks for the
> >>> report.
> >> Rethinking this, I think bio_init() is doing the right thing, only
> >> pktcdvd seems to rely on it preserving some members. So I'd rather fixup
> >> pktcdvd instead.
> >>
> >> Does this work for you?
> > 
> > Well, it's better: I was able to mount the DVD-RW, sync, and write data,
> > but kernel oopsed when I unmounted the drive:
> 
> Jens,
> 
> this patch, applied on top of your previous patch, solved it.
> 
> 
> 
> pktcdvd: don't rely on bio_init() preserving bio->bi_destructor

Ah great, thanks for following up on this! Applied.

-- 
Jens Axboe

