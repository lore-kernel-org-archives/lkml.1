Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbXHWCjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbXHWCjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXHWCjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:39:44 -0400
Received: from waste.org ([66.93.16.53]:38162 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXHWCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:39:43 -0400
Date: Wed, 22 Aug 2007 21:40:37 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070823024036.GP11166@waste.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu> <20070817105918.GA13937@hmsreliant.think-freely.org> <20070817124547.5415a839.akpm@linux-foundation.org> <20070821185611.GA17822@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821185611.GA17822@hexapodia.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:56:11AM -0700, Andy Isaacson wrote:
> On Fri, Aug 17, 2007 at 12:45:47PM -0700, Andrew Morton wrote:
> > On Fri, 17 Aug 2007 06:59:18 -0400
> > Neil Horman <nhorman@tuxdriver.com> wrote:
> > > Currently, there exists no method for a process to query the resource
> > > limits of another process.  They can be inferred via some mechanisms
> > > but they cannot be explicitly determined.  Given that this
> > > information can be usefull to know during the debugging of an
> > > application, I've written this patch which exports all of a
> > > processes limits via /proc/<pid>/limits.
> > 
> > I'm struggling with this a bit.  Sure, it _might_ be handy on some
> > occasions to be able to get at this information.  But I've never seen
> > anyone ask for it before, and it _is_ determinable by other means, if only
> > strace.
> 
> I've wanted this information on multiple occasions in the past and was
> mystified that there was no way to determine it.  And no, I don't feel
> that strace is an answer -- given a running process, how do I use strace
> to find out what its current ulimits are?

You stop it and force it to execute rlimit(2) in its context, of
course! What could be simpler? 

The reason we never see questions about this is because relatively few
people are using limits. Instead we see weekly questions about fork
bombs.

Frankly, I'd rather see new syscalls to get and set limits on other
processes in the same way we can set priorities, affinities, etc.. But
there are a couple dragons lurking there..

-- 
Mathematics is the supreme nostalgia of our time.
