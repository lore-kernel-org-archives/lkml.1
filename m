Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYHFPkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYHFPkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbYHFPea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:34:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421AbYHFPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:34:27 -0400
Date: Wed, 6 Aug 2008 08:25:55 -0700
From: Greg KH <greg@kroah.com>
To: tvrtko.ursulin@sophos.com
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080806152555.GD13996@kroah.com>
References: <20080805201535.GC27192@kroah.com> <20080806093800.1428B316899@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806093800.1428B316899@pmx1.sophos.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:37:06AM +0100, tvrtko.ursulin@sophos.com wrote:
> Greg KH wrote on 05/08/2008 21:15:35:
> 
> > > > > Perf win, why bothering looking for malware in /proc when it can't
> > > > > exist?  It doesn't take longer it just takes time having to do
> > > > > 
> > > > > userspace -> kernel -> userspace -> kernel -> userspace
> > > > > 
> > > > > just to cat /proc/mounts, all of this could probably be alliviated 
> if we
> > > > > cached access on non block backed files but then we have to come 
> up with
> > > > > a way to exclude only nfs/cifs.  I'd rather list the FSs that 
> don't need
> > > > > scanning every time than those that do....
> > > > 
> > > > How long does this whole process take?  Seriously is it worth the 
> added
> > > > kernel code for something that is not measurable?
> > > 
> > > Is it worth having 2 context switches for every open when none are
> > > needed?  I plan to get numbers on that.
> > 
> > Compared to the real time it takes in the "virus engine"?  I bet it's
> > totally lost in the noise.  Those things are huge beasts with thousands
> > to hundreds of thousands of context switches.
> 
> No, because we are talking about a case here where we don't want to do any 
> scanning. We want to detect if it is procfs (for example) as quickly as 
> possible and don't do anything. Same goes for any other filesystem where 
> it is not possible to store arbitrary user data.

See previous messages about namespaces and paths for trying to figure this
kind of information out in a sane way within the kernel.

> > > > > In kernel caching is clearly a huge perf win.
> > > > 
> > > > Why?  If the cache is also in userspace, it should be the same, 
> right?
> > > 
> > > In kernel cache has 0 context switches for every open.  Userspace
> > > caching has 2.  Every open has to block, switch to the context of the
> > > userspace client/cache, get that decisions, and then switch back to 
> the
> > > original process.
> > 
> > Again, compared to what?  If you in userspace are doing big complex
> > things, such an overhead is trivial.
> 
> Again similar thing as above - In case of a cache we are not doing complex 
> things.

Except for the overhead of keeping a cache :)

> So I think you can't argue that because scanning is slow everything
> else has to go to userspace. On a typical running system scanning is
> exceptional and everything else benefits from being in the fast path.

I really can not judge as we have not seen an implementation yet.

thanks,

greg k-h
