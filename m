Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbXHWKyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbXHWKyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXHWKxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:53:55 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2974 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXHWKxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:53:54 -0400
Date: Thu, 23 Aug 2007 06:53:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070823105314.GA21034@hmsreliant.think-freely.org>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <20070816123538.GA10430@hmsreliant.think-freely.org> <4379.1187338166@turing-police.cc.vt.edu> <20070817105918.GA13937@hmsreliant.think-freely.org> <20070817124547.5415a839.akpm@linux-foundation.org> <20070821185611.GA17822@hexapodia.org> <20070823024036.GP11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823024036.GP11166@waste.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 09:40:37PM -0500, Matt Mackall wrote:
> On Tue, Aug 21, 2007 at 11:56:11AM -0700, Andy Isaacson wrote:
> > On Fri, Aug 17, 2007 at 12:45:47PM -0700, Andrew Morton wrote:
> > > On Fri, 17 Aug 2007 06:59:18 -0400
> > > Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > Currently, there exists no method for a process to query the resource
> > > > limits of another process.  They can be inferred via some mechanisms
> > > > but they cannot be explicitly determined.  Given that this
> > > > information can be usefull to know during the debugging of an
> > > > application, I've written this patch which exports all of a
> > > > processes limits via /proc/<pid>/limits.
> > > 
> > > I'm struggling with this a bit.  Sure, it _might_ be handy on some
> > > occasions to be able to get at this information.  But I've never seen
> > > anyone ask for it before, and it _is_ determinable by other means, if only
> > > strace.
> > 
> > I've wanted this information on multiple occasions in the past and was
> > mystified that there was no way to determine it.  And no, I don't feel
> > that strace is an answer -- given a running process, how do I use strace
> > to find out what its current ulimits are?
> 
> You stop it and force it to execute rlimit(2) in its context, of
> course! What could be simpler? 
> 
I would think reading a file in /proc would be simpler :), especially if you're
in a position where attaching to the process through ptrace isnt feasible. For
instance, if you were an application running as the result of a core dump when
/proc/sys/kernel/core_pattern were a pipe, preforming your operation wouldn't be
particularly possible.  Likewise, if your a sysadmin and you want to check what
your processes limits were, you could follow your method, but I would think you
would much rather avoid needing to send several ptrace commands to your
commands, interrupting its work if you didn't have to.

> The reason we never see questions about this is because relatively few
> people are using limits. Instead we see weekly questions about fork
> bombs.
> 
But we do see questions about this. I've had a few requests, and at least two
more people have popped up on this thread supporting it.

Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
