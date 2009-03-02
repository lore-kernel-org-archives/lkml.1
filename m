Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZCBDh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZCBDh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZCBDhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:37:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:39540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZCBDhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:37:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,287,1233561600"; 
   d="scan'208";a="115626043"
Date: Mon, 2 Mar 2009 11:36:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: recursive slqb_lock
Message-ID: <20090302033638.GA8096@localhost>
References: <20090226053450.GA31108@localhost> <20090301150725.GB26905@wotan.suse.de> <20090301170015.GC26905@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301170015.GC26905@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Sun, Mar 01, 2009 at 07:00:15PM +0200, Nick Piggin wrote:
> On Sun, Mar 01, 2009 at 04:07:25PM +0100, Nick Piggin wrote:
> > On Thu, Feb 26, 2009 at 01:34:50PM +0800, Wu Fengguang wrote:
> > > Hi Nick,
> > > 
> > > I got a lockdep warning. It looks like the slqb_lock will be taken
> > > twice in the call chain:
> > > 
> > >         s_start()  => take slqb_lock
> > >           s_show()
> > >             gather_stats()  => take slqb_lock again
> > 
> > Hey, thanks for this. The following patch should fix it.
> > 
> > --
> > Fix the lockdep error reported by Fengguang where down_read slqb_lock
> > is taken twice, with the possibility for a deadlock.
> > 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>

> > +static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
> > +{
> > +	down_read(&slqb_lock); /* hold off hotplug */
> > +	gather_stats(s, stats);
> > +	up_read(&slqb_lock);
> > +}
> 
> Oops, I didn't test it. That call should be to gather_stats_locked of
> course.

Yeah it fixed the lockdep warning :)

Thanks,
Fengguang
