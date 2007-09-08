Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXIHFMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXIHFMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 01:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXIHFM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 01:12:26 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6707 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXIHFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 01:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZSaVwHZ+mnqPsMV6nUONisH7smGxSd1RFYqVWZORn3nqiKF+5QB9CUQJ4B1lF5yY9hl9CocrRXhK0bof5Xg5ci7UCKVyUxW0ichwiZNuBFH7eK44W+TS/3B0i1hheaGLr62eeLHQhbWcY/m2w4YRxxyQrvI3ro9wJ3Ml8mF3StQ=
Message-ID: <170fa0d20709072212m4563ce76sa83092640491e4f3@mail.gmail.com>
Date: Sat, 8 Sep 2007 01:12:24 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "David Miller" <davem@davemloft.net>, "Nick Piggin" <npiggin@suse.de>
In-Reply-To: <200709050916.04477.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070814142103.204771292@sgi.com>
	 <200709050220.53801.phillips@phunq.net>
	 <Pine.LNX.4.64.0709050334020.8127@schroedinger.engr.sgi.com>
	 <200709050916.04477.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Daniel Phillips <phillips@phunq.net> wrote:
> On Wednesday 05 September 2007 03:42, Christoph Lameter wrote:
> > On Wed, 5 Sep 2007, Daniel Phillips wrote:
> > > If we remove our anti-deadlock measures, including the
> > > ddsnap.vm.fixes (a roll-up of Peter's patch set) and the request
> > > throttling code in dm-ddsnap.c, and apply your patch set instead,
> > > we hit deadlock on the socket write path after a few hours
> > > (traceback tomorrow).  So your patch set by itself is a stability
> > > regression.
> >
> > Na, that cannot be the case since it only activates when an OOM
> > condition would otherwise result.
>
> I did not express myself clearly then.  Compared to our current
> anti-deadlock patch set, you patch set is a regression.  Because
> without help from some of our other patches, it does deadlock.
> Obviously, we cannot have that.

Can you be specific about which changes to existing mainline code were
needed to make recursive reclaim "work" in your tests (albeit less
ideally than peterz's patchset in your view)?

Also, in a previous post you stated:

>   Just to recap, we have identified two essential ingredients in the
> recipe for writeout deadlock prevention:
>
>  1) Throttle block IO traffic to a bounded maximum memory use.
>
>  2) Guarantee availability of the required amount of memory.

Which changes allowed you to address 1?  I had a look at the various
patches you provided (via svn) and it wasn't clear which subset
fulfilled 1 for you.  Does it work for all Block IO and not just
specially tuned drivers like ddsnap et al?

regards,
Mike
