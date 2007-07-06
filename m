Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbXGFGz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbXGFGz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbXGFGzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:55:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbXGFGzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:55:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Fri, 6 Jul 2007 09:02:53 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>, nigel@suspend2.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl> <200707052231.27780.rjw@sisk.pl> <20070705220046.GC3881@elf.ucw.cz>
In-Reply-To: <20070705220046.GC3881@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060902.55090.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 00:00, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The syncing of filesystems from within the freezer is generally not needed.
> > Change freeze_processes() so that it doesn't execute sys_sync() and make the
> > suspend and hibernation code path sync filesystems independently of the freezer.
> 
> Yes, we can do that, but ... why?

I think that sync and the freezer are different things and shouldn't be mixed in
such a way as they are now.

> Does it actually fix FUSE?

It should prevent the freezer from deadlocking.

> Miklos claims sync is nop on FUSE...? 

In that case there shouldn't be any deadlock, but a freezer failure. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
