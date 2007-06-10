Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbXFJXKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbXFJXKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 19:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXFJXKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 19:10:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:48492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841AbXFJXKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 19:10:39 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Date: Mon, 11 Jun 2007 01:10:35 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706041630.49316.agruen@suse.de> <1181135397.3699.53.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1181135397.3699.53.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3086
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200706110110.35553.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 15:09, Stephen Smalley wrote:
> On Mon, 2007-06-04 at 16:30 +0200, Andreas Gruenbacher wrote:
> > On Monday 04 June 2007 15:12, Pavel Machek wrote:
> > > How will kernel work with very long paths? I'd suspect some problems,
> > > if path is 1MB long and I attempt to print it in /proc
> > > somewhere.
> > 
> > Pathnames are only used for informational purposes in the kernel, except 
> > in AppArmor of course.
> 
> I don't mean this as a flame, but isn't the above statement the very
> crux of this discussion?

I think the question at the core of it all is, shall a pathname based security 
mechanism be allowed. I was under the impression that this question had 
already been answered affirmatively. If the answer here was no, then we could 
stop the entire discussion right there.

> Why should AppArmor be different from the rest of the kernel in its usage of
> pathnames (basis for decisions vs. informational reporting to userspace)? 
> And if it is ok for AppArmor to generate and use pathnames as its basis of
> decisions on each open, then is it also ok for audit, inotify, and others to
> use them in the same manner?

Audit and inotify don't make any decisions based on pathnames, or on SELinux 
labels for that matter, they only report. That being said, sure those parts 
of the kernel that report pathnames should report them correctly -- I guess 
there is no disagreement about that.

> Another question:  it seems like the read-only bind mount folks gave up
> on propagating the vfsmounts down and switched to a rather different
> approach (checking near the entry points, using mount writer counters).
> So similarly, what makes AppArmor fundamentally different that it
> wouldn't take a similar approach to what they are doing vs. propagating
> the vfsmounts down?

Without the vfsmounts propagated down you won't know the pathnames. Whether 
or not a different problem can be solved without the vfsmounts is not really 
relevant.

Thanks,
Andreas
