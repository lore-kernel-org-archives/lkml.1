Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZCXKcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZCXKcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZCXKcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:32:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbZCXKcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:32:03 -0400
Date: Tue, 24 Mar 2009 11:31:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
Cc: David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324103111.GA26691@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > I have not had this problem since I applied Arjan's (for some reason
> > > repeatedly rejected) patch to change the ioprio of the various writeback
> > > daemons. Under some loads changing to the noop I/O scheduler also seems
> > > to help (as do most of the non default ones)
> > 
> > (link would be useful)
> 
> 
> "Give kjournald a IOPRIO_CLASS_RT io priority"
> 
> October 2007 (yes its that old)

thx. A more recent submission from Arjan would be:

    http://lkml.org/lkml/2008/10/1/405

Resolution was that Tytso indicated it went into some sort of ext4 
patch queue:

| I've ported the patch to the ext4 filesystem, and dropped it into 
| the unstable portion of the ext4 patch queue.
|
|   ext4: akpm's locking hack to fix locking delays

but 6 months down the line and i can find no trace of this upstream 
anywhere.

<let-me-rant-too>

The thing is ... this is a _bad_ ext3 design bug affecting ext3 
users in the last decade or so of ext3 existence. Why is this issue 
not handled with the utmost high priority and why wasnt it fixed 5 
years ago already? :-)

It does not matter whether we have extents or htrees when there are 
_trivially reproducible_ basic usability problems with ext3.

	Ingo
