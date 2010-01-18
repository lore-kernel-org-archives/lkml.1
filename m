Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584Ab0ARU6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0ARU6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176Ab0ARU6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:58:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50209 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab0ARU6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:58:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: Memory allocations in .suspend became very unreliable)
Date: Mon, 18 Jan 2010 21:59:25 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1001181116340.6554-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001181116340.6554-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182159.25585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Alan Stern wrote:
> On Mon, 18 Jan 2010, Oliver Neukum wrote:
> 
> > Am Montag, 18. Januar 2010 00:00:23 schrieb Rafael J. Wysocki:
> > > On Sunday 17 January 2010, Benjamin Herrenschmidt wrote:
> > > > On Sun, 2010-01-17 at 14:27 +0100, Rafael J. Wysocki wrote:
> > > ...
> > > > However, it's hard to deal with the case of allocations that have
> > > > already started waiting for IOs. It might be possible to have some VM
> > > > hook to make them wakeup, re-evaluate the situation and get out of that
> > > > code path but in any case it would be tricky.
> > > 
> > > In the second version of the patch I used an rwsem that made us wait for these
> > > allocations to complete before we changed gfp_allowed_mask.
> > 
> > This will be a very, very hot semaphore. What's the impact on performance?
> 
> Can it be replaced with something having lower overhead, such as SRCU?

I'm not sure about that.  In principle SRCU shouldn't be used if the reader can
sleep unpredictably long and the memory allocation sutiation is one of these.

Rafael
