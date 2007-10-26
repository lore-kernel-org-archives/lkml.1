Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbXJZC36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbXJZC36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbXJZC3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:29:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39307 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbXJZC3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:29:50 -0400
Date: Thu, 25 Oct 2007 19:29:45 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071025192945.82962eea.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, when a task with MPOL_INTERLEAVE has its cpuset mems_allowed expanded 
> to include more memory.  The task itself can't access all that memory with 
> the memory policy of its choice.

That much I could have guessed (did guess, actually.)

Are you seeing this in a real world situation?  Can you describe the
situation?  I don't mean just describing how it looks to this kernel
code, but what is going on in the system, what sort of job mix or
applications, what kind of users, ...  In short, a "use case", or brief
approximation thereto.  See further:

  http://en.wikipedia.org/wiki/Use_case

I have no need of a full blown use case; just a three sentence
mini-story should suffice.  But it should (if you can, without
revealing proprietary knowledge) describe a situation you have
actual need of addressing.

> So my change allows those tasks that have already expressed the
> desire to interleave their memory with MPOL_INTERLEAVE to always
> use the full range of memory available that is dynamically changing
> beneath them as a result of cpusets.

Yup, that it does.  Note that it is a special case -- "the full range",
not any application controlled specific subset thereof, short of
reissuing set_mempolicy() calls anytime that the applications cpuset
'mems' changes.

> The only other way to support such a feature is through a modification to 
> mempolicies themselves, which Lee has already proposed.  The problem with 
> that is it requires mempolicy support for cpuset cases and modification to 
> the set_mempolicy() API.

Do you have a link to what Lee proposed?  I agree that a full general
solution would seem to require a new or changed set_mempolicy API,
which may well be more than we want to do, absent a more compelling
"use case" requiring it than we have now.

> I find it hard to believe that a single cpuset with a single
> memory_spread_user boolean is going to include multiple tasks that
> request interleaved mempolicies over differing nodes within the
> cpuset's mems_allowed.  That, to me, is the special case.

That may well be, to you.  To me, pretty much -all- uses of
set_mempolicy() are special cases ;).  I have no way of telling
whether or not there are users who would require multiple tasks
in the same cpuset to have different interleave masks, but since
the API clearly supports that (except when changing cpuset 'mems'
settings mess things up), I have been presuming that somewhere in
the universe, such users exist or might come to exist.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
