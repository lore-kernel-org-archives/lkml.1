Return-Path: <linux-kernel-owner+w=401wt.eu-S1764725AbYHEUWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764725AbYHEUWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764597AbYHEURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:17:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:60745 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764576AbYHEURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:17:48 -0400
Date: Tue, 5 Aug 2008 13:15:35 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805201535.GC27192@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <1217965563.27684.159.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217965563.27684.159.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 03:46:03PM -0400, Eric Paris wrote:
> On Mon, 2008-08-04 at 17:51 -0700, Greg KH wrote:
> > On Mon, Aug 04, 2008 at 08:32:54PM -0400, Eric Paris wrote:
> 
> > Oh, and after that, not using a binary interface, have we not learned
> > from the ioctl mess?  I sure thought we had...
> 
> I don't see a reason why we can't use strings and key=value pairs for
> any metadata being sent back and forth.  That seem more reasonable?

Sure, but do you really want to put a parser in the kernel (well, make
that, yet-another-parser-in-the-kernel...)?

> > > > Heh, so if you want to write a "virus" for Linux, just implement this
> > > > flag.  What's to keep a "rogue" program from telling the kernel that all
> > > > programs on the system are to be excluded?
> > > 
> > > Processes can only get this flag one of 2 ways.
> > > 
> > > 1) register as a client to make access decisions
> > 
> > How do you do that?
> 
> open the magic "vetting" file RW and you are a client who can answer
> access decisions.

What's to keep anyone from doing this?

> > > Perf win, why bothering looking for malware in /proc when it can't
> > > exist?  It doesn't take longer it just takes time having to do
> > > 
> > > userspace -> kernel -> userspace -> kernel -> userspace
> > > 
> > > just to cat /proc/mounts, all of this could probably be alliviated if we
> > > cached access on non block backed files but then we have to come up with
> > > a way to exclude only nfs/cifs.  I'd rather list the FSs that don't need
> > > scanning every time than those that do....
> > 
> > How long does this whole process take?  Seriously is it worth the added
> > kernel code for something that is not measurable?
> 
> Is it worth having 2 context switches for every open when none are
> needed?  I plan to get numbers on that.

Compared to the real time it takes in the "virus engine"?  I bet it's
totally lost in the noise.  Those things are huge beasts with thousands
to hundreds of thousands of context switches.

> > > In kernel caching is clearly a huge perf win.
> > 
> > Why?  If the cache is also in userspace, it should be the same, right?
> 
> In kernel cache has 0 context switches for every open.  Userspace
> caching has 2.  Every open has to block, switch to the context of the
> userspace client/cache, get that decisions, and then switch back to the
> original process.

Again, compared to what?  If you in userspace are doing big complex
things, such an overhead is trivial.

And again, realize that Linux has the fastest context switches _by far_
of any other operating system.  It is ok to do things in userspace, we
are used to that :)

thanks,

greg k-h
