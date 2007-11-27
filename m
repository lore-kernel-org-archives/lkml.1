Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbXK0Bal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbXK0Bal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXK0Bad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:30:33 -0500
Received: from paragon.brong.net ([74.52.187.94]:45111 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXK0Bac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:30:32 -0500
Date: Tue, 27 Nov 2007 12:30:28 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: [PATCH 1/1] mm: add dirty_highmem option
Message-ID: <20071127013028.GA31038@brong.net>
References: <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <20071122034204.GA14079@brong.net> <alpine.LFD.0.9999.0711260949490.5869@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711260949490.5869@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 09:53:17AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 22 Nov 2007, Bron Gondwana wrote:
> > 
> > This patch includes some code cleanup from Linus and a toggle in
> > /proc/sys/vm/dirty_highmem which can be set to 1 to add the highmem
> > back to the total available memory count.
> 
> Just to verify - can you confirm that this "just fixes it" for you?
> 
> I think this is the right approach to take, and seems very safe (ie people 
> who know that their loads are ok can just set the flag), but I do want to 
> verify that there was nothing else going on, and that you now see the same 
> performance as you did in 2.6.16?
> 
> The other alternative, of course, would be to simply allow the dirty 
> percentages to be > 100%, but that's just *odd* ;)

Yes, toggling dirty_highmem "just fixes it" in all our tests.  I hadn't
tested it on the production machine yet - but I'm just installing it
there now since it's been running fine on a less important machine for
a few days now.

I did wonder about allowing the dirty percentage to go way up, but that
would have cause "this one goes up to 110%" comments in the sysctl
limits code and people would have thought I was childish.  Can't have
that.  Much better to have "int one = 1" instead.

Bron.
