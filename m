Return-Path: <linux-kernel-owner+w=401wt.eu-S1761709AbXGCVZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761709AbXGCVZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbXGCVZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:25:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998AbXGCVZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:25:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:32:48 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain>
In-Reply-To: <1183497290.3388.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032332.49694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 23:14, Benjamin Herrenschmidt wrote:
> 
> > >  - For STR, don't do the freezer thing.
> > 
> > In the long run, I agree.
> > 
> > Still, can you please read this post from Alan Stern:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.html
> > 
> > ?  I don't think I'm able to repeat the arguments given in there in a
> > convincing way.
> 
> That's the same crackpot I've been hearing for the past 3 years or
> so ...
> 
> Both Paulus and I think the freezer is just a way to try to put your
> head in the sand and ignore the problem. It causes as many problems as
> it solves on its own, and is just not a solution that will be of any use
> once you start implementing dynamic PM schemes etc...
> 
> In many cases, having proper support for "live" suspend of devices is
> just a matter of having a couple of helpers in whatever subsystem those
> drivers hookup with. In the case of network, for example, it's mostly
> trivial (stop the queue). For block, it's not terribly hard neither,
> though you want to have some orderign/atomicity between the blocking of
> the incoming request queue and the sending of things like spindown &
> flush commands to the disk. For old-style IDE, that was fairly easily
> solved by piping suspend/resume command down the request queue itself
> and have the queue block/unblbock itself after processing them. Some of
> that logic could maybe be moved to the block layer for all block drivers
> to benefit.
> 
> But yes, overall, there is work to do on drivers and I'm doing the ones
> I hit on the platforms I use. I don't think the freezer is any kind of
> remotely good solution, just a way to continue avoiding the problem.

Still, do you really think that we're ready to drop it _right_ _now_ (I'm
referring to suspend only) and if so than on what basis (except that you
don't like it, which falls short of being a techical argument)?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
