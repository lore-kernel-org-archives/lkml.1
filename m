Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464Ab0AHAnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0AHAnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AHAnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:43:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0AHAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:43:30 -0500
Date: Fri, 8 Jan 2010 01:43:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
Message-ID: <20100108004329.GE16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost> <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost> <20100107235149.GD16076@basil.fritz.box> <1262909682.2659.45.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262909682.2659.45.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 07:14:42PM -0500, Trond Myklebust wrote:
> On Fri, 2010-01-08 at 00:51 +0100, Andi Kleen wrote: 
> > > I'd like to see this fixed, but I do not want to jump onto a solution
> > > that changes the behaviour of mmap() w.r.t. revalidation. The current
> > > behaviour dates back at least to 2.3.x if not before.
> > 
> > So do you have a plan to fix it?
> 
> Yes. I want to pursue Peter Zijlstra's patches, which split up the mmap
> function into a set of parts which require the mmap_sem, and other parts
> which don't, and that adds a filesystem callback that allows for
> revalidation to occur outside the mmap_sem.

Is that really a 2.6.33 solution?

It sounds intrusive.

> 
> > I don't think it'll be possible to do drastic changes in the
> > VFS for 2.6.33, and it seems preserving the current semantics
> > would need that.
> > 
> > > That's why I'm working slowly on this.
> > 
> > Delaying a fix to after 2.6.33 is not an option imho.
> > 
> > It hits everyone with LOCKDEP enabled who uses mmap over NFS.
> > That's new in 2.6.33, previously LOCKDEP didn't diagnose this.
> > 
> > I'll keep using my patch, but I suppose once we're going more
> > towards a release you'll get more reports of this.
> 
> Why should this particular issue require us to rush into a solution?

Because every lockdep user NFS+mmap gets spammed now.

That's like having an oops in the startup sequence. The system
might still boot, but users are not happy.

> This has been there for literally _years_, and I've never heard of a
> single incident in which a deadlock actually occurred. The only reason
> why we've noticed it at all is because lockdep has started to whine.

I bet there were deadlocks somewhere, probably just didn't get reported.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
