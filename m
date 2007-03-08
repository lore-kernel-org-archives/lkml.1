Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXCHXfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXCHXfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161208AbXCHXfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:35:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37270 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161107AbXCHXfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:35:41 -0500
Date: Fri, 9 Mar 2007 00:35:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       nigel@nigel.suspend2.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: Suspend/resume semantics for ISDN drivers (was: NAK new drivers without proper power management?)
Message-ID: <20070308233520.GD2793@elf.ucw.cz>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <45CFB06B.5080102@imap.cc> <45E9FB54.4030905@imap.cc> <200703042004.26684.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703042004.26684.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On 12.02.2007 01:10 I wrote:
> > > I don't doubt your basic assessment. However it doesn't translate that
> > > easily into a real implementation. In my case, I maintain a USB driver,
> > > so I have to deal with USB specifics of suspend/resume which happen not
> > > to be that well documented. My driver provides an isdn4linux device but
> > > isdn4linux knows nothing about suspend/resume so I am on my own on how
> > > to reconcile the two. The device itself, though in turn far from trivial,
> > > is actually the least of my worries.
> > 
> > So, how *should* an isdn4linux driver handle a request to suspend?
> > Specifically, if there are active connections, should it try to
> > shut them down in an orderly fashion (which might imply some delays
> > waiting for the remote station to acknowledge, etc.)? Should it kill
> > them abruptly (as for a USB unplug event)? Or should it just refuse
> > to suspend while a connection is still active?
> 
> I think that refusing to suspend wouldn't be a good approach (think of an
> emergency suspend when the battery is running low).
> 
> Probably the closing of connections would be the nicest thing from the
> user's point of view.

It depends on "how long does connection close take". If it is more
than few seconds, kill them abruptly.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
