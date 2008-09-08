Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYIHTNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYIHTNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYIHTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:13:40 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30594 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753005AbYIHTNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:13:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mhMzQs+y6Qy4kjVhyP7NrAIlsRS9zC1Ax7EQa+PFXjIujJ0Ma5yiGHQD8iz6cQ5TNLjKKQlhAm5VC6IibFZf5/zdwYxTUJr8tNB9TTi0qgB185cCvfVMOqoabhAX7PFH5QJ0r64X0CcEEHbgpjz/l5PcA2dEDRx6+LC+ysRq7NI=  ;
X-YMail-OSG: ABwjWCkVM1lmRe5mFGTpyNI99kuShUY4UmMVKwUxDMmKCvVqoaCmAiJPpKNoTM8RLSZrwsx0kWcO0NANwzkfYEDOixnJ12k69eu8QpT8nw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 12:13:37 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>
References: <1220889205.8074.16.camel@localhost.localdomain> <200809081119.45074.david-b@pacbell.net> <1220899189.8074.58.camel@localhost.localdomain>
In-Reply-To: <1220899189.8074.58.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081213.37705.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, James Bottomley wrote:
> On Mon, 2008-09-08 at 11:19 -0700, David Brownell wrote:
> > On Monday 08 September 2008, James Bottomley wrote:
> > > Put it back again by making RTC_CLASS 
> > > unselectable if the architecture is parisc.
> > 
> > Easier if those distros just wouldn't select RTC_CLASS then.  :)
> 
> Yes, but think of distro config people rather like users ... if you can
> prevent them from doing something stupid, it's a good idea.  In this
> case, there's currently no way anyone should ever select RTC_CLASS on
> parisc, so we should make that clear in the Kconfig file.

Preventing them from doing stupid stuff is exactly why we
have Kconfig prevent both legacy *AND* framework RTC code
from being selected.  :)

Of course stupidity is infinite, and we didn't know about
this particular instance in advance...


> > And long term, better to work with RTC_CLASS.  Eliminate that
> > crufty asm-parisc/rtc.h file and one more GEN_RTC user; and
> > share more widely-used infrastructure.
> > 
> > If I read things right, that would be easy:  the PARISC RTC is
> > two firmware calls, ptc_tod_{read,set}(), which would map to
> > RTC class {read,set}_time() methods of about six lines each.
> > The RTC framework can do UIE emulation, if needed.
> 
> OK, I can look at that, but in the mean time could we make the option
> that causes the damage unselectable?

I'd worry if "the mean time" takes too long.  But lacking a
PARISC laptop to fix this on, I'm unlikely to complain much.


>	 This is technically a regression 
> because before your patch GEN_RTC would override RTC_CLASS, now it's the
> other way around.

Well, previously there was no override ... I think you mean
that parisc just completely ignored RTC_CLASS, treating it
like junk DNA.

- Dave
