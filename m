Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZCLIsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZCLIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZCLIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:48:06 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:43092 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750852AbZCLIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:48:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mXnfCy9wUIbWYw2gOyxbrCEILPhX4qhkDP3mJUZ347bIFVFixMPR4qToG2+LijBmf3wrrHWvrlFqUJaEoQ+n+2htA/M1qd4IYOVNVdAf2yD6e6fbdlMsYZyt7EpFjkPjSRU0nZWJIwvqS3y1gB0WEVTlArS1ckRjnZjtY14L82o=  ;
X-YMail-OSG: fbT4IGAVM1kAQZeFAgSQ66f2EVACdZx8oJW1fgl7ZP_Kp3DGtFZAENZwo.8WtshQlNPsgGfhl6tdHHFJGEui7cxBqQZGEARZyJOhV_dqqflhPoKXx0vamTGu9HP3LDjv0AEHivkbf80HJZIOi5kcorLiJss5euietMe52Dn.UUqqmqIc.ATcCX7_FQOURg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 19:47:57 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org> <200903120133.02645.phillips@phunq.net>
In-Reply-To: <200903120133.02645.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121947.58367.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 19:33:02 Daniel Phillips wrote:
> On Wednesday 11 March 2009, Andrew Morton wrote:

> > > Obviously, that raises the question of whether C99 syntax is banned in
> > > kernel.
> >
> > It is banned ;)
> >
> > I'm not sure why, really - I have vague memories of Linus having an
> > episode...  It seems an OK construct if used tastefully.  Although it
> > does make it easy to hide nasty surprises.
> > ...
> > Well.  As I say, it doesn't bother me much (but I like C++, so ignore
> > me).  But it will make merge/review life harder for you at the outset.
> > How much harder I cannot predict.  People will fixate on this issue
> > at the expense of everything else..
>
> Well, I suppose we will do something in the middle for now: change some
> to K&R, and leave some of it as is where we expect it to be developed
> heavily, like dleaf.c which is going to see whole bunch of work to
> integrate versioning, so it really makes little sense to make it harder
> to factor just before starting that work.  Anyway, the C++ comments are
> on their way out and after all that is the one people love to hate.

I think they need to be fixed before merge. If the function is easier
to follow when you use this feature, IMO it indicates the function is
too big or badly written anyway.


> There are a couple of issues, one is u64 being (long) instead of
> (long long) as you say, and the other is variable type sizes like
> loff_t.  That specific one isn't actually a problem, we can just refuse
> to support 32 bit libc file ops, but there may be others.  We had a
> world of pain before (L) arrived, then with (L) it was easy.  Maybe
> just edit them all to (long long) for now, and damn the line length.

Yes please do this. A significant style change like this that lots of
code already does I think is best first discussed as a standalone
change to kernel rather than everyone developing their own convention.


