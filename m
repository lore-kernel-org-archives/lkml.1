Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbXD2J1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbXD2J1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbXD2J1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:27:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36486 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbXD2J1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:27:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
Date: Sun, 29 Apr 2007 11:32:10 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704291057.48747.rjw@sisk.pl> <20070429085937.GD1900@elf.ucw.cz>
In-Reply-To: <20070429085937.GD1900@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291132.11409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 10:59, Pavel Machek wrote:
> Hi!
> 
> > > Ie we do have history of _not_ freezing things.  The freezing came later, 
> > > and came with the subsystem that had more problems..
> > 
> > It doesn't have that many problems as you are trying to suggest.  At present,
> > the only problems with it happen if someone tries to "improve" it in the way
> > I did with the workqueues.
> > 
> > Anyway, the freezing of tasks, including kernel threads, is one of the few
> > things on which Pavel, Nigel and me completely agree that they should be done,
> > so perhaps you could accept that?
> 
> Actually, if we want to support OLPC _nicely_, we'll need to get rid
> of freezer from suspend-to-RAM. Of course, that _will_ put more
> pressure at the drivers -- and break few of them...

I think the removal of sys_sync() from freeze_processes() in the s2ram case
might help.

I'm really afraid of dropping the freezing of kernel threads from the
hibernation/suspend altogether before we know we won't break drivers, because
we can introduce some very subtle and difficult to debug problems this way.

Moreover, apart from speeding up the suspend slightly (kernel threads are
frozen very quickly) this won't buy us anything, since kprobes uses the freezer
and all of the infrastructure is needed anyway.

Greetings,
Rafael
