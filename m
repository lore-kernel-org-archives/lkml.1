Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbZIGTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbZIGTuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZIGTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:50:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59184 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZIGTun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:50:43 -0400
Date: Mon, 7 Sep 2009 21:50:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 3/8] writeback: switch to per-bdi threads for flushing
	data v2
Message-ID: <20090907195045.GI18599@kernel.dk>
References: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com> <1252050406-22467-4-git-send-email-jens.axboe@oracle.com> <20090904105403.GD19857@duck.suse.cz> <20090904115858.GT18599@kernel.dk> <20090904120407.GV18599@kernel.dk> <20090907183659.GB29103@duck.suse.cz> <20090907184517.GF18599@kernel.dk> <20090907194531.GD29103@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907194531.GD29103@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Jan Kara wrote:
> On Mon 07-09-09 20:45:18, Jens Axboe wrote:
> > On Mon, Sep 07 2009, Jan Kara wrote:
> > >   Hi Jens,
> > > 
> > >   now I've found just two minor things (see below). Besides them the only
> > > thing which is blocking my ack is a way to effectively lookup a BDI from a
> > > superblock so that we can reasonably effectively fsync a superblock...
> > 
> > Can we side step that as an inclusion criteria, please? I'd really like
> > to work on adding that quick lookup, but I'd also hate to potentiall
> > destabilize anything at this point. So we can probably quite easily make
> > .32 as well for that, but I'd rather not risk doing a version and
> > include that from the beginning. OK?
>   Well, for now I thought about a simple hack like a pointer to
> backing_dev_info in a superblock. That should work for every filesystem
> right now and shouldn't be too complex...

Oh certainly, it wont be complex. But there's still a risk with
operations such as that, referencing to something new...

>   But if you promise you'll fix that up before 2.6.32 is released, I'm OK
> with your patch as is. I'll give your patches some testing with some less
> usual benchmarks this week and if that works out fine you have my ack.

I promise :-)

Let me post a new version tomorrow, and you can base your tests off
that.

-- 
Jens Axboe

