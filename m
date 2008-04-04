Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYDDLAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYDDLAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYDDLAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:00:05 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:47467 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755016AbYDDLAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:00:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fOkqHAia9G0X4RvvCW1q4DdyqxKKuRfQBWcOrog4DflYom1w8ucyWnL7AvrINYBFFhcnKazBpg7IOMlAZS0c8OkNnO7RWRge/6exeIipK76YmwPX0M+vRIzTtbq1O6T7OAgrv9HPdSCCl28V5CMYUgQV9RrJJeV7AeMk0qcKJOA=  ;
X-YMail-OSG: Trw2xR0VM1n0t8bNGUNFyX42ivLW1XYrdrUaGY.Kha30Nl_6Turbf3zrN1IxkaFHwsyDMFwdVw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: 7eggert@gmx.de
Subject: Re: GFP_ATOMIC page allocation failures.
Date: Fri, 4 Apr 2008 21:59:53 +1100
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <adYyJ-20N-11@gated-at.bofh.it> <aeqF6-45P-29@gated-at.bofh.it> <E1Jhib4-0000md-FP@be1.7eggert.dyndns.org>
In-Reply-To: <E1Jhib4-0000md-FP@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804042159.54220.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008 20:52, Bodo Eggert wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 03 April 2008 05:18, Jeff Garzik wrote:
> >> Turning to Nick's comment,
> >>
> >> > It's still actually nice to know how often it is happening even for
> >> > these known good sites because too much can indicate a problem and
> >> > that you could actually bring performance up by tuning some things.
> >>
> >> then create a counter or acculuation buffer somewhere.
> >>
> >> We don't need spew every time there is memory pressure of this
> >> magnitude.
> >
> > Not a complete solution. Counter would be nice, but you need backtraces
> > and want a way to more proactively warn the user/tester/developer.
> >
> > I agree that I don't exactly like adding nowarns around, and I don't
> > think places like driver writers should have to know about this stuff.
>
> What about reverse ratelimiting: If the limit is reached, a backtrace will
> be generated (and, off cause, positively ratelimited)?

I was thinking about that. I got as far as writing a simple patch to
printk  so that it would not start to trigger until it gets a 2nd event
within 'n' jiffies of the first.

But actually developers do sometimes want see the event even if it is
relatively infrequent...
