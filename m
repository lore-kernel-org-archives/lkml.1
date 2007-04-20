Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDTXf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDTXf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDTXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:35:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbXDTXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:35:25 -0400
Date: Fri, 20 Apr 2007 16:34:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pdelaney@bluelane.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Piet Delaney <piet@bluelane.com>, Tom Rini <trini@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, Dave Jiang <djiang@mvista.com>,
       linux-kernel@vger.kernel.org,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@FreeBSD.org>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Message-Id: <20070420163450.d8c8b3b7.akpm@linux-foundation.org>
In-Reply-To: <1177109495.9479.81.camel@piet2.bluelane.com>
References: <20070307204516.GA24095@blade.az.mvista.com>
	<200703081814.53153.ak@suse.de>
	<45F04B6E.9000703@mvista.com>
	<200703081937.56167.ak@suse.de>
	<20070308184940.GP11626@smtp.west.cox.net>
	<1173392650.8912.236.camel@piet2.bluelane.com>
	<20070417113016.1f0812c7.randy.dunlap@oracle.com>
	<1177109495.9479.81.camel@piet2.bluelane.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 15:51:35 -0700
Piet Delaney <pdelaney@bluelane.com> wrote:

> > Is there any movement on this?
> 
> Hi Randy:
> 
> Jason Wessel <jason.wessel@windriver.com> is currently leading yet
> another attempt at getting kgdb permanently into the kernel. Jason
> has a linux2_6_21 patch on SourceForge:
> 	
> http://kgdb.cvs.sourceforge.net/kgdb/kgdb-2/8250.patch?view=log&pathrev=linux2_6_21_uprev
> 
> and has been working with Sergei Shtylyov <sshtylyov@ru.mvista.com>
> recently on getting KGDBOE Netpoll patches that got lost around the 
> time of Tom's attempt. Just on Monday there were a dozen posting to 
> the source forge mailing list:
> 
> 	
> 
> kgdb-bugreport@lists.sourceforge.net
> 
> on this effort.

Unfortunately there doesn't seem to be anything there which I can autopull
into the -mm tree.  I'm presently set up for quilt trees in open
directories and for git trees.  I could add plain-old-gzipped-diffs or
whatever.

> I'd like to see a git repository on kernel.org that is used to update
> the mainstream kernel. Unfortunately getting accounts on kernel.org is
> next to impossible. If Jason doesn't have one yet it would be nice to
> offer him one for the kgdb developers to use. 

This seems to be to do with some silly spamfilter issue or something.  I
sent an email off-list.

> I agree with Andi that the kgdb code seems to be getting more
> complicated that needed thought I don't find the hooks offensive.
> Here I keep my kgdb hooks completely under #ifdef KGDB, so there
> is absolutely no difference to the kernel when KGDB isn't configured.

We can address that sort of thing via review: you send send the diffs out,
we read them and comment on them.  We do this 100 times a day - it is
simply a non-issue, as long as there's actually someone who has the
time/effort/inclination to push this feature to completion, which is what
kgdb has sadly lacked for the past decade or so.

> I also like having debug printks, similar to the SOCK_DEBUG() macros,
> to make it easy to watch kgdb internals in action. Ya can't run kgdb
> on itself. 
> 
> I find these blemish's a minor concern compared to the damage/lost
> of not integrating kgdb into the kernel permanently. When developers
> can't rely on using kgdb for easy development they tend to write code
> without consideration for what it's like using their code with the
> debugger. Linux is making a major headway into $100 embedded systems;
> the recent use in the Linksys WRT54GL (DD-WRT) and Engenius EOC-3220
> for example. Making kgdb easily accessible will make the viability of
> using Linux for embedded system greatly increased, IMHO. 

Lots of people want kgdb.  One person is famously less keen on it, but
we'll be able to talk him around, as long as the patches aren't daft.

> Perhaps with a bit of support from the kernel.org folks we could get
> the kgdb patch, with all of it's blemishes, into Andrews 2.6.21-rc7-mm1
> patch. Accounts on kernel.org for kgdb developers would be a modest
> effort. I find the CVS patch framework rather clumsy and would rather
> follow the KISS principle and just use git repositories like the rest
> of the kernel developers appear to be using.

Yes, a git tree on k.org is appropriate - let's make that happen.

But beware that it will need to be updated pretty reguarly, and it'll need
to be against Linux-tree-of-the-day, please.  The x86 code continues to
change at a tremendous rate (I count 204 x86 patches queued for 2.6.22),
and kgdb supports lots of other architectures too.

So whoever is signed up to maintain this will have quite a bit of messy
maintaneance to do during the getting-it-ready phase.  This will of course
be minimised by being VERY careful to mimimise the impact of the patchset
on the existing code.

And if/when it is merged, there will be quite a bit of tricky maintenance
work to do, if my experience of the kgdb stub is anything to go by.

There inevitably will be long-term low-level impact upon the arch
maintainers too.  But that's OK, because the way to merge this feature is
to put the arch-neutral core into the tree first, and to then send each
per-arch patch to the relevant arch maintainer for merging.  That way, they
get to decide whether they wish to take on the burden of participating in
its long-term maintenance.

