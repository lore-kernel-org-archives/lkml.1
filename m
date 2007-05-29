Return-Path: <linux-kernel-owner+w=401wt.eu-S1751350AbXE2WIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbXE2WIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbXE2WHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:07:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39563 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE2WHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:07:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Tue, 29 May 2007 23:55:14 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <200705270012.59177.rjw@sisk.pl> <200705291415.31970.rjw@sisk.pl> <20070529124816.GI23046@elf.ucw.cz>
In-Reply-To: <20070529124816.GI23046@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705292355.15563.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 14:48, Pavel Machek wrote:
> Hi!
> 
> > > Well.. it can write anywhere it wants (filesystem or not) as long as
> > > the system is not going to be confused after resume by its caches not
> > > matching on-disk state. I'd prefer it not to write anywhere at all.
> > 
> > OK
> > 
> > Please have a look at the current version of the patch (appended).
> > 
> > I have followed the Nigel's suggestion not to change the current behavior
> > in this patch (I'll add a couple of patches removing the freezability from
> > some kernel threads), with one exception: I couldn't figure out any reason
> > to have try_to_freeze() called in net/sunrpc/svcsock.c:svc_recv() .
> 
> It probably broke suspend at some point... leave it there. Processes
> can stay in D period, waiting for NFS server to come back.
> 
> and yes, we want nfs threads frozen, too (and anything that talks to
> network). Speaking to nfs servers while we are suspending the machine
> is not nice, and if that continues after snapshot, we'll act as a very
> confused machine to the outside...

OK, I've added set_freezable() to the NFS-related threads.

[Updated patch is in the reply to Nigel.]

Greetings,
Rafael
