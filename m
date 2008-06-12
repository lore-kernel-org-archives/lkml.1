Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbYFLL1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYFLL1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 07:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFLL1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 07:27:30 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:47439 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750786AbYFLL13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 07:27:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Iaz7R33tw7Hwj7QrwtzfszbHvnt0nRELL/T9BjcpVr3iMwHDiFKEdnn/kxC7QWZDjC5Y1RsEi+CwuMlqj+UGC6zbQVy8qo01+5thHU1GO6VumDAAjbKAiE8v+SsEwrYI1SW82u7WPxeahZV4GeSPufFXI/svLWcT8U5Yw0j5zyw=  ;
X-YMail-OSG: xl7mGq8VM1mC.ZaQuo0xsnfZRY1ZqPdBll8nspGgoqcMp_QoOaWkpIIMssb_5fks4hoZ._sH2GXAA3RXjHRV.UA.iEwAQlCcBRAZFBcAMMd_jbN5w4zwwO31USRhOi0GML8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: MMIO and gcc re-ordering issue
Date: Thu, 12 Jun 2008 21:27:18 +1000
User-Agent: KMail/1.9.5
Cc: linux-arch@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <200806111329.35894.nickpiggin@yahoo.com.au> <200806110907.12070.jbarnes@virtuousgeek.org>
In-Reply-To: <200806110907.12070.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806122127.19230.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 02:07, Jesse Barnes wrote:
> On Tuesday, June 10, 2008 8:29 pm Nick Piggin wrote:

> > You mention strong ordering WRT spin_unlock, which suggests that
> > you would prefer to take option #2 (the current powerpc one): io/io
> > is ordered and io is contained inside spinlocks, but io/cacheable
> > in general is not ordered.
>
> I was thinking it would be good for the weaker accessors, but now that I
> think about it you could just use the new io_* barrier functions.
>
> I didn't mean to imply that I wasn't in favor of the io/cacheable ordering
> as well.
>
> > For any high performance drivers that are well maintained (ie. the
> > ones where slowdown might be noticed), everyone should have a pretty
> > good handle on memory ordering requirements, so it shouldn't take
> > long to go through and convert them to relaxed accessors.
>
> Yep.  Thanks for working on this, Nick, it's definitely a good thing that
> you're taking control of it. :)

Well, I really am just trying to help the kernel for everyone (and every
architecture). Performance for all architectures really is my #2 priority,
so if any arch becomes irrepearably slower under a proposal I would
go back to the drawing board.

I'll come up with a proposal in the form of an initial code+documentation
patch when I get some more time on it.
