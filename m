Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbXIEMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbXIEMEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXIEME3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:04:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbXIEME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:04:28 -0400
Date: Wed, 5 Sep 2007 05:02:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Cc: davidel@xmailserver.org, rdunlap@xenotime.net, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       drepper@redhat.com, stable@kernel.org, hch@lst.de,
       jengelh@computergmbh.de, corbet@lwn.net
Subject: Re: [PATCH] Revised timerfd() interface
Message-Id: <20070905050225.d6355ab3.akpm@linux-foundation.org>
In-Reply-To: <20070905000831.313400@gmx.net>
References: <20070825064114.107820@gmx.net>
	<Pine.LNX.4.64.0708300458120.7717@alien.or.mcafeemobile.com>
	<46DD116C.4040301@gmx.net>
	<20070904011800.762523a4.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
	<20070904204932.208520@gmx.net>
	<Pine.LNX.4.64.0709041541500.7326@alien.or.mcafeemobile.com>
	<20070905000831.313400@gmx.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 05 Sep 2007 02:08:31 +0200 "Michael Kerrisk" <mtk-manpages@gmx.net> wrote:
> Davide,
> 
> > > As I think about this more, I see more problems with
> > > your argument.  timerfd needs the ability to get and 
> > > get-while-setting just as much as the earlier APIs.
> > > Consider a library that creates a timerfd file descriptor that
> > > is handed off to an application: that library may want
> > > to modify the timer settings without having to create a
> > > new file descriptor (the app mey not be able to be told about
> > > the new fd).  Your argument just doesn't hold, AFAICS.
> > 
> > Such hypotethical library, in case it really wanted to offer such 
> > functionality, could simply return an handle instead of the raw fd, and 
> > take care of all that stuff in userspace.
> 
> Did I miss something?  Is it not the case that as soon as the
> library returns a handle, rather than an fd, then the whole
> advantage of timerfd() (being able to select/poll/epoll on 
> the timer as well as other fds) is lost?  
> 
> > Again, mimicking POSIX APIs doesn't always take you in the right place.
> 
> POSIX may goof in places, but in general it is the result of
> many smart people thinking about how to design/standardize APIs.
> So the onus is on us to explain why they got this point wrong.
> And it is not merely POSIX that did things things in the
> way I've described: so did the earlier setitimer()/getitimer().
> 

<wakes up even more>

Seems that we need to pay some more attention to this, as time is pressing
and we should get this stuff finalised in 2.6.23.

Which means that most of us have some catching-up to do.

Michael, could you please refresh our memories with a brief, from-scratch
summary of what the current interface is, followed by a summary of what you
believe to be the shortcomings to be?  
