Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZA1HBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZA1HBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 02:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZA1HBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 02:01:09 -0500
Received: from 1wt.eu ([62.212.114.60]:1873 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZA1HBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 02:01:09 -0500
Date: Wed, 28 Jan 2009 07:59:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Greg KH <gregkh@suse.de>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128065912.GC32725@1wt.eu>
References: <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <20090128053642.GL5038@1wt.eu> <alpine.DEB.1.10.0901272142530.20262@alien.or.mcafeemobile.com> <20090128062021.GA32360@1wt.eu> <alpine.DEB.1.10.0901272226370.20262@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901272226370.20262@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 10:36:25PM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Willy Tarreau wrote:
> 
> > Davide, I know it's not you who decide. I mean, one patch was proposed
> > with one arbitrary limit. I've seen it in advance too and I too thought
> > it would be more than enough. Now people are reporting breakage from
> > common applications which work in a funny way (I think that using epoll
> > to poll for one single FD in a multi-process architecture can be called
> > funny). But those people are not expected to understand the internals,
> > and most likely their application's behaviour might not be more precisely
> > described than "it broke since upgrade to 2.6.27.13".
> > 
> > I think we should accept the fact that the fix is causing problems
> > for people while it was not expected to do so. One of the solutions
> > would be to increase the arbitrary ratio from 1% to more than that,
> > but it will still break big setups. Another solution is to accept
> > that the patch provides a tunable that admins might act on to stop
> > local users' nasty activities if required, but leave the limit off
> > by default. And I think that's a saner approach, especially for a
> > stable series.
> 
> Absolutely. There is no 100% fit solution here. Heck, if we want to remove 
> the tunable altogether I'm the happiest one, but the problem with the 
> pinneable memory is there.

we shouldn't remove the tunable IMHO.

> We can decide to remove the caps in the default setup, and leave default 
> setups open to the DoS. I've no problem with that (and, as we know, I 
> don't decide policies).
> Then sysadmins of multiuser systems will have to enforce the caps 
> themselves in order to limit the potential DoS. This is probably a good 
> strategy for -stable anyway.

Yes, this is what I'd like to see in -stable too. I'm currently contacting
a few people I suggested to upgrade to 2.6.27.13 to warn them about the
issue.

Regards,
Willy

