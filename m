Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbXK0VMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbXK0VMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXK0VMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:12:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42155 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbXK0VMO (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:12:14 -0500
Date: Wed, 28 Nov 2007 08:11:58 +1100
From: David Chinner <dgc@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS related Oops (suspend/resume related)
Message-ID: <20071127211155.GK119954183@sgi.com>
References: <20071112064706.GA23595@dose.home.local> <20071126210844.GB119954183@sgi.com> <200711262307.56742.rjw@sisk.pl> <200711271651.39180.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711271651.39180.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 04:51:38PM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, David Chinner wrote:
> > > Now there's a message that I haven't seen in about 3 years.
> > > 
> > > It indicates that the linux inode connected to the xfs_inode is not
> > > the correct one. i.e. that the linux inode cache is out of step with
> > > the XFS inode cache.
> > > 
> > > Basically, that is not supposed to happen. I suspect that the way
> > > threads are frozen is resulting in an inode lookup racing with
> > > a reclaim. The reclaim thread gets stopped after any use threads,
> > > and so we could have the situation that a process blocked in lookup
> > > has the XFS inode reclaimed and reused before it gets unblocked.
> > > 
> > > The question is why is it happening now when none of that code in
> > > XFS has changed?
> > > 
> > > Rafael, when are threads frozen? Only when they schedule or call
> > > try_to_freeze()?
> > 
> > Kernel threads freeze only when they call try_to_freeze().  User space tasks
> > freeze while executing the signals handling code.
> > 
> > > Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?
> > 
> > Yes.  Kernel threads are not sent fake signals by the freezer any more.
> 
> Ah, sorry, this change has been merged after 2.6.23.  However, before 2.6.23
> we had another important change that caused all kernel threads to have
> PF_NOFREEZE set by default, unless they call set_freezable() explicitly.

So try_to_freeze() will never freeze a thread if it has not been
set_freezable()? And xfsbufd will never be frozen?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
