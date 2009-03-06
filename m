Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZCFPih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZCFPih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbZCFPiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:38:24 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:48163 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbZCFPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:38:23 -0500
Date: Fri, 6 Mar 2009 21:08:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: lockdep warning with 2.6.29-rc6-mm1 (mmotm 24-feb-2009)
Message-ID: <20090306153808.GA863@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090304125709.GA6251@balbir.in.ibm.com> <1236173267.5330.7487.camel@laptop> <20090304174115.GE25962@elte.hu> <20090305070045.GC11916@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090305070045.GC11916@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin <npiggin@suse.de> [2009-03-05 08:00:45]:

> On Wed, Mar 04, 2009 at 06:41:15PM +0100, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, 2009-03-04 at 18:27 +0530, Balbir Singh wrote:
> > > > I see the following on my machine. My understanding is that the
> > > > lockdep warning is complaining about a potential deadlock while
> > > > reclaiming, where we could end up waiting on holding inotify_mutex,
> > > > and we could end up calling reclaim with inotify_mutex held.
> > > > 
> > > > The race seems rare, since one path shows a new inode being created
> > > > and the other one being deleted. It seems like a false positive unless
> > > > the inode's in question turn out to be potentially the same.
> > > 
> > > Its not a false positive until you can guarantee the inodes will _never_
> > > be the same.
> > > 
> > > This thing has been reported numerous times, Ingo even posted 
> > > a potential fix for it, Nick poked the inotify people to speak 
> > > up, but they have so far been silent on the issue :-(
> > 
> > that particular fix is upstream, via:
> > 
> >   3023a3e: inotify: fix GFP_KERNEL related deadlock
> > 
> > so does this reproduce with latest .29-rc7-ish kernels too - or 
> > do we have some other problem in this area too?
> 
> Well as I said, I think it is just a bandaid to shut up lockdep,
> because I think inotify always is guaranteed to have a ref on
> the inode at this point so it should not be subject to reclaim.

I got dropped from the cc and thus could not respond earlier. The
problem can be seen even in 2.6.29-rc7-mm1.

-- 
	Balbir
