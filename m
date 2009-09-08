Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZIHK51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZIHK51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZIHK50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:57:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39069 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZIHK5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:57:25 -0400
Date: Tue, 8 Sep 2009 12:57:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes()
	export
Message-ID: <20090908105728.GU18599@kernel.dk>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-2-git-send-email-jens.axboe@oracle.com> <4AA631AA.6000803@gmail.com> <20090908104111.GS18599@kernel.dk> <1252407150.5060.51.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252407150.5060.51.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08 2009, Artem Bityutskiy wrote:
> On Tue, 2009-09-08 at 12:41 +0200, Jens Axboe wrote:
> > On Tue, Sep 08 2009, Artem Bityutskiy wrote:
> > > Hi Jens,
> > >
> > > On 09/08/2009 12:23 PM, Jens Axboe wrote:
> > >>   	int i, err;
> > >>   	struct ubifs_info *c = sb->s_fs_info;
> > >> -	struct writeback_control wbc = {
> > >> -		.sync_mode   = WB_SYNC_ALL,
> > >> -		.range_start = 0,
> > >> -		.range_end   = LLONG_MAX,
> > >> -		.nr_to_write = LONG_MAX,
> > >> -	};
> > >>
> > >>   	/*
> > >>   	 * Zero @wait is just an advisory thing to help the file system shove
> > >> @@ -462,7 +456,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
> > >>   	 * the user be able to get more accurate results of 'statfs()' after
> > >>   	 * they synchronize the file system.
> > >>   	 */
> > >> -	generic_sync_sb_inodes(sb,&wbc);
> > >> +	sync_inodes_sb(sb);
> > >
> > > This call is unnecessary and I've removed it and the patch is sitting in
> > > linux-next for long time:
> > > http://git.infradead.org/ubifs-2.6.git/commit/887ee17117fd23e962332b353d250ac9e090b20f
> > >
> > > Stephen e-mailed about the conflict recently. Could we please resolve the
> > > conflict? I guess if you pick up my patch then git will be able to resolve
> > > stuff automatically.
> > 
> > Would seem weird for me to carry your patch. As the issue is resolved in
> > -next, I'd say we just let whomever gets to merge last resolve it at
> > their end.
> 
> That's Linus. Do you think it is nice to send him a pull request which
> for sure requires requires manual work?

No, that's not what I wrote, you should never send Linus a pull request
that requires manual merging. One of us gets to resolve it, depending on
who gets to send the latter pull request.

> But well, if you do not want to carry my patch, then I'll have to
> re-base my tree later, fix stuff, and send a pull request. I mean,
> your stuff will for sure be merged first, because I send pull requests
> late, just because UBIFS is a minor thing in the kernel.

You don't have to rebase, if my work is merged first then you just merge
Linus' tree into yours and fixup the conflict before asking Linus to
pull.

It's a trivial conflict, I don't understand what the fuzz is about.

-- 
Jens Axboe

