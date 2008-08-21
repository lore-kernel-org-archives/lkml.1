Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYHURJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYHURJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHURJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:09:00 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:61460 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbYHURI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:08:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMw7rUh5LD0w/2dsb2JhbAC2Y4Fm
X-IronPort-AV: E=Sophos;i="4.32,246,1217773800"; 
   d="scan'208";a="176645432"
Date: Fri, 22 Aug 2008 03:08:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821170854.GJ5706@disturbed>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	gus3 <musicman529@yahoo.com>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808211700.39584.nickpiggin@yahoo.com.au> <20080821085332.GG5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808211933.34565.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 07:33:34PM +1000, Nick Piggin wrote:
> > > But existing plugging is below the level of the elevators, and should
> > > only kick in for at most tens of ms at queue idle events, so it sounds
> > > like it may not be your problem. Elevators will need some hint to give
> > > priority to specific requests -- either via the current threads's io
> > > priority, or information attached to bios.
> >
> > It's getting too bloody complex, IMO. What is right for one elevator
> > is wrong for another, so as a filesystem developer I have to pick
> > one to target.
> 
> I don't really see it as too complex. If you know how you want the
> request to be handled, then it should be possible to implement.

That is the problem in a nutshell. Nobody can keep up with all
the shiny new stuff that is being implemented,let alone the
subtle behavioural differences that accumulate through such
change...

> > With the way the elevators have been regressing, 
> > improving and changing behaviour,
> 
> AFAIK deadline, AS, and noop haven't significantly changed for years.

Yet they've regularly shown performance regressions because other
stuff has been changing around them, right?

> > I am starting to think that I 
> > should be picking the noop scheduler.
> > Any 'advanced' scheduler that 
> > is slower than the same test on the noop scheduler needs fixing...
> 
> I disagree. On devices with no seek penalty or their own queueing,
> noop is often the best choice. Same for specialized apps that do
> their own disk scheduling.

A filesystem is nothing but a complex disk scheduler that
has to handle vastly larger queues than an elevator. Іf the
filesystem doesn't get it's disk scheduling right, then the
elevator is irrelevant because nothing will fix the I/O
problems in the filesystem algorithms.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
