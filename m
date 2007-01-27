Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbXA0DCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbXA0DCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 22:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXA0DCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 22:02:41 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:24020 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751828AbXA0DCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 22:02:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HqdoR6CLUP2KboL3v7q6aDc8jG6vUlayKlAH2r+GhJCUVfxHLRxwM1flTW4dqEbsmsr6zuOWL1yZHxg0Ezozndg/yqAMNhgiC8SwG9bNUheCb0fT/JVgPPuH7QELJfB/cApbUBIlDwIG5c5iDmDWFPzTF5y6XVObuBSL3pYB80k=  ;
X-YMail-OSG: MnlcJbUVM1kKXfu6Z5mFSM560ecbbRpQE9v62cS2VtJAecs0hg1cjeidC0GIgW0fSV9vo.id32BEwaEljCNdRpqENWMH749.iOXRDdNkJaM3iRf6shG9dpwZWZjn4Gaf4Zb4Qj4-
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Fri, 26 Jan 2007 19:02:37 -0800
User-Agent: KMail/1.7.1
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20061219185223.GA13256@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net> <20070127011954.GA13534@srcf.ucam.org>
In-Reply-To: <20070127011954.GA13534@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261902.38247.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 5:19 pm, Matthew Garrett wrote:
> On Fri, Jan 26, 2007 at 04:42:56PM -0800, David Brownell wrote:
> > On Friday 26 January 2007 3:15 pm, Matthew Garrett wrote:
> > > It's certainly the case that fixing those drivers would result in a 
> > > better long-term situation - however, nobody currently seems to have any 
> > > interest in doing so...
> > 
> > And the way these things work, unfortunately, is that merging your patch
> > would ensure nobody ever gets such interest.  Removing that "state" file
> > (and its bogus infrastructure) has already taken a few years too long.
> 
> I'd argue that the onus is on those who wish to remove the interface to 
> ensure that equivalent functionality exists first.

Are you now arguing that "rmmod $DRIVER" doesn't suffice for what you
were wanting to do?  If so, why?  What's the delta in power usage?


> Now this is what throws me somewhat. Last May, you argued strongly in 
> favour of keeping the interface:
> 
> "Which IMO makes removing this a Bad Thing.  It needs to have some
> kind of replacement in place before the "magic numbers" go away."
> 
> (http://lists.osdl.org/pipermail/linux-pm/2006-May/002376.html)

Specifically to support driver testing.  Recall that such testing was
at that time the only known quasi-viable use of that interface.  (And
despite your pushback, it still seems that way to me...)

I've changed my mind about that; it's just as easy to whip up custom test
logic, and in any case the stuff that I most needed to test (wakeup
events) can't be tested like that.  Bad testing infrastructure doesn't
really do anyone favors, anyway; too much time spent with workarounds,
many of which cover up the bugs you're trying to uncover by testing.

- Dave

