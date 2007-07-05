Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXGEVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXGEVcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbXGEVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:32:25 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:34862 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906AbXGEVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:32:25 -0400
To: oliver@neukum.org
CC: stern@rowland.harvard.edu, miklos@szeredi.hu, pavel@ucw.cz,
       paulus@samba.org, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707052315.38770.oliver@neukum.org> (message from Oliver
	Neukum on Thu, 5 Jul 2007 23:15:38 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <Pine.LNX.4.44L0.0707051704580.2557-100000@iolanthe.rowland.org> <200707052315.38770.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I6YvE-00025u-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 23:31:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, 5 Jul 2007, Oliver Neukum wrote:
> > 
> > > > Obviously. Â But I wasn't about the server trying to acquire a lock
> > > > held by a client. Â I was talking about a client trying to acquire a
> > > > lock held by _another_ client.
> > > > 
> > > > If this coincides with the server (or some other task which the server
> > > > is depending on) being frozen before the clients, the freezer has a
> > > > problem.
> > > 
> > > True, but that case can only happen if servers are frozen before clients.
> > > You don't need a full dependency graph. A simple set sequence of two
> > > classes of tasks will do.
> > 
> > Just to make things more complicated...  Since a server isn't
> > restricted in what it can do, what happens when one server depends on
> > another server?
> 
> The same principle applies. If you really want that you can solve this
> by freezing servers in the reverse sequence they were started.

You just can't know what constitutes a "server", processes which read
from the fuse device are candidates, but all tasks which communicate
with these in some way are also.  And that basically makes every
userspace task in the system a candidate server and you are no further
than before.

> The main point remains. If you have a circular dependency anywhere
> among the servers you can deadlock independent of the freezer.

Well, Duh.

Miklos
