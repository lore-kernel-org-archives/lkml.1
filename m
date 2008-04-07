Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYDGSFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYDGSFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYDGSEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:04:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44419 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbYDGSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:04:50 -0400
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804071844350.14273@blonde.site>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site>
	 <1207524935.3223.39.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0804070145550.28303@blonde.site>
	 <Pine.LNX.4.64.0804071844350.14273@blonde.site>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 13:04:42 -0500
Message-Id: <1207591482.3838.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 18:51 +0100, Hugh Dickins wrote:
> On Mon, 7 Apr 2008, Hugh Dickins wrote:
> > On Sun, 6 Apr 2008, James Bottomley wrote:
> > > 
> > > This was sort of accidentally fixed in scsi-misc by commit 
> > > 
> > > commit c5f73260b289cb974928eac05f2d84e58ddfc020
> > > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Date:   Thu Mar 13 11:16:33 2008 -0500
> > > 
> > >     [SCSI] consolidate command allocation in a single place
> > 
> > Thanks, yes, that looks a good substitute to me.
> > 
> > > Could you check that:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > > 
> > > and see if it alleviates the problem? ... if so, we can work out which
> > > pieces to backport.
> > 
> > Precisely that patch seems appropriate to 2.6.25-rc8-git, so I'm now
> > running the test with just that applied to 2.6.25-rc8 (plus cfq rcu
> > fix).  Not quite what you asked, but...
> > 
> > Strictly speaking, it'd take a couple of days to be reasonably sure
> > that the livelock is gone (it appeared to reproduce quicker once I
> > moved to -rc8 plus cfq rcu fix; but I'm not entirely convinced that
> > wasn't just coincidence).  But if nothing bad appears overnight,
> > let's assume your patch is the one to push: I'll report tomorrow.
> 
> Right, as expected, that seems to run fine: I've seen no problem with
> it in 17 hours - beyond, of course, all the page allocation failures
> which will plague such tests until something else is changed.
> 
> Somewhat irrelevant since Linus put my patch into 2.6.25-rc8-git
> (probably worth it for the various issues noted in the comment);
> but reassuring for 2.6.26.
> 
> I'll stop that test now and put it to work on something else.

Well ... just remember that to merge scsi-misc with what Linus has now
done, I'm effectively reversing your patch, so testing current scsi-misc
is very valuable if you want the problem not to recur in 2.6.26 ...

James


