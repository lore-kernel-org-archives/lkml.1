Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbXGEVPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbXGEVPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759731AbXGEVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:15:39 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:39620 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbXGEVPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:15:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 23:15:38 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <Pine.LNX.4.44L0.0707051704580.2557-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707051704580.2557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707052315.38770.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Alan Stern:
> On Thu, 5 Jul 2007, Oliver Neukum wrote:
> 
> > > Obviously.  But I wasn't about the server trying to acquire a lock
> > > held by a client.  I was talking about a client trying to acquire a
> > > lock held by _another_ client.
> > > 
> > > If this coincides with the server (or some other task which the server
> > > is depending on) being frozen before the clients, the freezer has a
> > > problem.
> > 
> > True, but that case can only happen if servers are frozen before clients.
> > You don't need a full dependency graph. A simple set sequence of two
> > classes of tasks will do.
> 
> Just to make things more complicated...  Since a server isn't
> restricted in what it can do, what happens when one server depends on
> another server?

The same principle applies. If you really want that you can solve this
by freezing servers in the reverse sequence they were started.

The main point remains. If you have a circular dependency anywhere
among the servers you can deadlock independent of the freezer.

	Regards
		Oliver
