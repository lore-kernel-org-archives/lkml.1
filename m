Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXGFWwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXGFWwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXGFWwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:52:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbXGFWwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:52:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 01:00:16 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org
References: <20070706202629.GA158@tv-sign.ru> <200707070038.25830.oliver@neukum.org>
In-Reply-To: <200707070038.25830.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707070100.17413.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 July 2007 00:38, Oliver Neukum wrote:
> Am Freitag, 6. Juli 2007 schrieb Oleg Nesterov:
> > Rafael J. Wysocki wrote:
> > >
> > > This patch makes the freezer skip uninterruptible user space tasks (ie. such
> > > that have an mm of their own) when counting the tasks to be frozen.  As a
> > > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> > > freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> > > will enter the refrigerator as soon as they change their state.
> > 
> > A small correction: they will enter the refrigerator on return to user-space.
> 
> That is too late. We would need them to go to sleep as soon as they are
> woken up. This does not matter if they are in uninterruptible sleep due to
> fuse deadlocking, as they won't be woken up, but it kills the other cases.

I'm sorry I can't write anything more about that right now, I'll write more
tomorrow.

For now, I can only say that I have reasons to believe that the other cases
are not likely to "leak" through the freezer.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
