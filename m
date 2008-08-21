Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYHUIy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYHUIy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYHUIyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:54:14 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:31164 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYHUIyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:54:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALDHrEh5LD0w/2dsb2JhbAC1WoFm
X-IronPort-AV: E=Sophos;i="4.32,244,1217773800"; 
   d="scan'208";a="176333807"
Date: Thu, 21 Aug 2008 18:53:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821085332.GG5706@disturbed>
Mail-Followup-To: Nick Piggin <nickpiggin@yahoo.com.au>,
	gus3 <musicman529@yahoo.com>,
	Szabolcs Szakacsits <szaka@ntfs-3g.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <684252.68814.qm@web34508.mail.mud.yahoo.com> <20080821061443.GD5706@disturbed> <200808211700.39584.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808211700.39584.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 05:00:39PM +1000, Nick Piggin wrote:
> On Thursday 21 August 2008 16:14, Dave Chinner wrote:
> 
> > I think that we need to issue explicit unplugs to get the log I/O
> > dispatched the way we want on all elevators and stop trying to
> > give elevators implicit hints by abusing the bio types and hoping
> > they do the right thing....
> 
> FWIW, my explicit plugging idea is still hanging around in one of
> Jens' block trees (actually he refreshed it a couple of months ago).
> 
> It provides an API for VM or filesystems to plug and unplug
> requests coming out of the current process, and it can reduce the
> need to idle the queue. Needs more performance analysis and tuning
> though.

We've already got plenty of explicit unplugs in XFS to get stuff
moving quickly - I'll just have to add another....

> But existing plugging is below the level of the elevators, and should
> only kick in for at most tens of ms at queue idle events, so it sounds
> like it may not be your problem. Elevators will need some hint to give
> priority to specific requests -- either via the current threads's io
> priority, or information attached to bios.

It's getting too bloody complex, IMO. What is right for one elevator
is wrong for another, so as a filesystem developer I have to pick
one to target. With the way the elevators have been regressing,
improving and changing behaviour, I am starting to think that I
should be picking the noop scheduler. Any 'advanced' scheduler that
is slower than the same test on the noop scheduler needs fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
