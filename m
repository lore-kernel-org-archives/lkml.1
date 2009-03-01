Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZCAXS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZCAXS2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZCAXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:18:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZCAXSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:18:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 2 Mar 2009 00:17:50 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <200902282353.39763.rjw@sisk.pl> <d6200be20902281538g1dd6aec4q1b42b610d3ea15d1@mail.gmail.com>
In-Reply-To: <d6200be20902281538g1dd6aec4q1b42b610d3ea15d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903020017.52390.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 March 2009, Arve Hjønnevåg wrote:
> On Sat, Feb 28, 2009 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 28 February 2009, Arve Hjønnevåg wrote:
> >> Can you summarize what the problems with my current api are? I get the
> >> impression that you think the overhead of using a list is too high,
> >> and that timeout support should be removed because you think all
> >> drivers that use it are broken.
> >
> > In no particular order:
> > 1. One user space process can create an unlimited number of wakelocks.  This
> >   shouldn't be possible.  Moreover, it is not even necessary for any process
> >   to have more than one wakelock held at any time.
> 
> This has been addressed. A user space process cannot create more
> wakelocks than it has filedescriptors.
> 
> > 2. Timeouts are wrong, because they don't really _solve_ any problem.  They are
> >   useful for working around the fact that you can't or you don't want to
> >   modify every piece of code that in principle should take a wakelock and
> >   that's it.
> 
> Yes, timeouts are sometimes wrong, but they are not always wrong. I
> gave two examples where the use of timeouts was not incorrect.

There still is a problem that the same operation can take time X on one
platform and time Y on another, so how are you going to determine the timeouts
that will be suitable for all platforms?

> >  However,  entire concept of having one code path acting on
> >   behalf of another one on a hunch that it might be doing something making
> >   suspend undesirable is conceptually broken IMO.
> 
> OK. Do you have an alternative?

Well, IMO every code path doing something that makes automatic suspend
undesirable should use a suspend blocker of some sort.  I'm afraid any other
approach will be unreliable and racy.

> I my opinion this is how the entire system works if you do autosuspend
> without a mechanism like wakelocks.

It surely hasn't been designed with automatic suspend in mind.

Thanks,
Rafael
