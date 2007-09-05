Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXIEMMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXIEMMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXIEMMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:12:32 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:64403 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbXIEMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=L/6oJWkPkMFQveAez5UTk/q+PCmmE+fQTMJyycCLCQfsQ88fiTD7L873fF1GRu7VbK8KBh+36u2QeZcEUqhe4T+yduzucQfCSml+3fSZKqCpIWnweroIS6ICM42RrPioTLjvY4YfFYSVdhvUvGexMDkK31lXuStY/1eJVJ0vrG4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] Revised timerfd() interface
Date: Wed, 5 Sep 2007 13:12:21 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>, rdunlap@xenotime.net,
       tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org, hch@lst.de,
       jengelh@computergmbh.de, corbet@lwn.net
References: <20070825064114.107820@gmx.net> <20070904011800.762523a4.akpm@linux-foundation.org> <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709040805490.6887@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051312.21873.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 16:25, Davide Libenzi wrote:
> On Tue, 4 Sep 2007, Andrew Morton wrote:
> 
> > > On Tue, 04 Sep 2007 10:03:56 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > > Davide,
> > > 
> > > >> Davide -- ping!  Can you please offer your comments about this change, and
> > > >> also thoughts on Jon's and my comments about a more radical API change
> > > >> later  in this thread.
> > > > 
> > > > IMO the complexity of the resulting API (and resulting patch), and the ABI 
> > > > change, is not justified by the added value.
> > > 
> > > Neither of the proposed APIs (either my multiplexed version of timerfd()
> > > or Jon's/my idea of using three system calls (like POSIX timers), or
> > > the notion of timerfd() integrated with POSIX timers) is more
> > > complicated than the existing POSIX timers API.
> > > 
> > > The ABI change doesn't really matter, since timerfd() was broken in 2.6.22
> > > anyway.
> > > 
> > > Both previous APIs provided the features I have described provide:
> > > 
> > > * the ability to fetch the old timer value when applying
> > >   a new setting
> > > 
> > > * the ability to non-destructively fetch the amount of time remaining
> > >   on a timer.
> > > 
> > > This is clearly useful for timers -- but you have not explained why
> > > you think this is not necessary for timerfd timers.
> > 
> > <wakes up>
> > 
> > I'd have thought that the existing stuff would be near-useless without the
> > capabilities which you describe?
> 
> Useless like it'd be a motorcycle w/out a cup-holder :)
> Seriously, the ability to get the previous values from "something" could 
> have a meaning if this something is a shared global resource (like signals 
> for example). In the timerfd case this makes little sense, since you can 
> create as many timerfd as you like and you do not need to share a single 
> one by changing/restoring the original context.

I think at least ability to read remaining time from a timerfd is needed.
--
vda
