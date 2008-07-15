Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYGOXKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYGOXKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYGOXKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbYGOXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:10:21 -0400
Date: Tue, 15 Jul 2008 16:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
Message-Id: <20080715160858.c70a54aa.akpm@linux-foundation.org>
In-Reply-To: <1216162567.7981.82.camel@localhost>
References: <20080715213241.GC23331@redhat.com>
	<1216161003.7981.73.camel@localhost>
	<20080715154323.b7d5f14d.akpm@linux-foundation.org>
	<1216162567.7981.82.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 18:56:07 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2008-07-15 at 15:43 -0700, Andrew Morton wrote:
> > On Tue, 15 Jul 2008 18:30:03 -0400
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Tue, 2008-07-15 at 17:32 -0400, Jason Baron wrote:
> > > > -convert sunrpc debug facility
> > > > 
> > > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > > 
> > > 
> > > Where the hell did this come from, what's its purpose, and WTF haven't
> > > you Cced linux-nfs@vger.kernel.org so that the rest of us can review it?
> > 
> > It's on linux-kernel.  If you don't have a linux-kernel subscription
> > then you should fix that.  Set up a procmail rule and do a
> > search-by-subject when needed.
> 
> I get my daily share of 1000-odd mails from linux-kernel, thanks, but
> 99% of that goes into the trashcan. I only keep a mail if I see that
> it's relevant.

Well stop doing that then.  Use procmail to assemble a local
linux-kernel archive and retain the last month or three's worth of
traffic.  This is trivial to set up and is pretty much essential
practice for a kernel subsystem maintainer such as yourself.

> In this case, 1 email out of 7 turns out to be relevant
> (after I inadvertently deleted the apparently crucial first 2 emails),
> and there is no changelog entry to tell me what's being done or why.
> 
> By Ccing the correct list, we at least get a heads-up that this thread
> might be important. I can't archive all of lkml on my laptop, but I can
> and do archive all of linux-nfs...

lkml is a mere 100MB/month.  Sorry, but you and others who are
operating at your level should really just do this.

Yes, it would be _better_ had Jason done the cc's perfectly, but as I
said before, that is most uncommon.

The main downside from what he did is that while it is reasonable to
assume that all top-level maintainers have a local lkml archive, it
is not reasonable to assume that _all_ interested-in-nfs individuals
have one as well.

But at least he copied _something_ to the right list.  That puts him
ahead of half the pack.

> > In this case, yes, it would have been nice if Jason had cc'ed lots of
> > different lists and individuals on the core patch and then selectively
> > cc'ed lists and individuals on the per-subsystem followup patches.  But
> > I doubt if even 2% of patch submitters manage to do all that correctly.
> 
> The point is that he is changing a semi-official interface for tracing
> the NFS kernel activity from userspace. I'd like to know why and how it
> is being modified before I can ack it.
> 
> In addition there are several other developers who have a daily interest
> in using this interface when helping our users, and who might have
> comments.

Sure.

What Jason is brewing up here is pretty major and ambitious revamp of
our current horridly-ad-hoc kernel debugging practices.  Look at this
piece of horror:

akpm:/usr/src/25> grep '^dprintk' Tags | wc -l
206

(I mean: wtf?)

So yeah, it will be traumatic and intrusive and a bit risky and will
require input and perhaps assistance from many developers.  But if we
can pull this off, the long-term benefits will be appreciable.

