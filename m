Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZCFPmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZCFPmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZCFPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:42:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZCFPl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:41:59 -0500
Subject: Re: lockdep warning with 2.6.29-rc6-mm1 (mmotm 24-feb-2009)
From: Eric Paris <eparis@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090306153808.GA863@balbir.in.ibm.com>
References: <20090304125709.GA6251@balbir.in.ibm.com>
	 <1236173267.5330.7487.camel@laptop> <20090304174115.GE25962@elte.hu>
	 <20090305070045.GC11916@wotan.suse.de>
	 <20090306153808.GA863@balbir.in.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 10:42:35 -0500
Message-Id: <1236354155.18817.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 21:08 +0530, Balbir Singh wrote:
> * Nick Piggin <npiggin@suse.de> [2009-03-05 08:00:45]:
> 
> > On Wed, Mar 04, 2009 at 06:41:15PM +0100, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Wed, 2009-03-04 at 18:27 +0530, Balbir Singh wrote:
> > > > > I see the following on my machine. My understanding is that the
> > > > > lockdep warning is complaining about a potential deadlock while
> > > > > reclaiming, where we could end up waiting on holding inotify_mutex,
> > > > > and we could end up calling reclaim with inotify_mutex held.
> > > > > 
> > > > > The race seems rare, since one path shows a new inode being created
> > > > > and the other one being deleted. It seems like a false positive unless
> > > > > the inode's in question turn out to be potentially the same.
> > > > 
> > > > Its not a false positive until you can guarantee the inodes will _never_
> > > > be the same.
> > > > 
> > > > This thing has been reported numerous times, Ingo even posted 
> > > > a potential fix for it, Nick poked the inotify people to speak 
> > > > up, but they have so far been silent on the issue :-(
> > > 
> > > that particular fix is upstream, via:
> > > 
> > >   3023a3e: inotify: fix GFP_KERNEL related deadlock
> > > 
> > > so does this reproduce with latest .29-rc7-ish kernels too - or 
> > > do we have some other problem in this area too?
> > 
> > Well as I said, I think it is just a bandaid to shut up lockdep,
> > because I think inotify always is guaranteed to have a ref on
> > the inode at this point so it should not be subject to reclaim.
> 
> I got dropped from the cc and thus could not respond earlier. The
> problem can be seen even in 2.6.29-rc7-mm1.

Ok, I'll take a look at it this afternoon.  Sadly I know those
allocations and object lifetimes all to well now.

-Eric

