Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXG2MTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXG2MTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbXG2MTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:19:37 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4762 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035AbXG2MTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:19:36 -0400
Date: Sun, 29 Jul 2007 08:19:04 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       wwoods@redhat.com, Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070729121904.GC9644@hmsreliant.homelinux.net>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net> <20070728161725.GA5836@piware.de> <20070728172142.GA10555@hmsreliant.homelinux.net> <20070729093418.GA5794@piware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729093418.GA5794@piware.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 11:34:18AM +0200, Martin Pitt wrote:
> Hi Neil,
> 
> Neil Horman [2007-07-28 13:21 -0400]:
> > Jeremy asked that I make a patch next week to address split_argv's requirement
> > that the argc parameter be non-NULL.  I'll be fixing that next week, and what I
> > can do is further enhance it such that it ignores spaces in quoted strings,
> > which should address the case that concerns you.  I.E I can make split_argv
> > behave such that:
> > echo "|\"foo bar\" --pid %p" > /proc/sys/kernel/core_pattern
> > results in the following argv:
> > {{"foo bar"}, {"--pid"}, {"1234"}}
> > 
> > Which I think handles what you are looking for.
> 
> Oh, handling escaping and quoting is going to make it fairly
> complicated, but sure, if you need that for other things, too, that
> would solve the remaining case. I just wonder if, instead of
> implementing escaping, it wouldn't be easier to first split on spaces
> and then escape macros?
> 
If it were just this case, then yes.  But we also need to make this work
properly for when core_pattern is not a pipe.  So the macro expansion routine
needs to be generalized somewhat.  Certainly doable, it just takes a bit more
testing and care in coding.  I'll start looking into it in the upcomming week.

> > Thank you for clearing me up on this.  So it would seem we're ok with what we
> > have now, correct?  
> 
> Absolutely, yes.
> 
> > We just have a potential corner case to address, which I can
> > reasonably handle with a modification to split_argv, that I have a
> > todo on next week.
> 
> Right, it's really just for perfectionism. Spaces in executable names
> are EBW anyway, and readlink()ing /proc/<pid>/exe is much more robust
> anyway in terms of a small and orthogonal interface.
> 
Understood.

> If the upstream kernel guys don't worry about it and consider it a
> blocker for merging, I don't either. :-)
> 
Copy that

Thanks & Regards
Neil

> Thanks a lot,
> 
> Martin
> 
> -- 
> Martin Pitt        http://www.piware.de
> Ubuntu Developer   http://www.ubuntu.com
> Debian Developer   http://www.debian.org



-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
