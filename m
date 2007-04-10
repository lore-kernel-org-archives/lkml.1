Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXDJU5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXDJU5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXDJU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:57:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXDJU5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:57:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Tue, 10 Apr 2007 23:00:28 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <200704072320.40238.rjw@sisk.pl> <200704081902.35857.rjw@sisk.pl> <20070409123920.GA4251@ucw.cz>
In-Reply-To: <20070409123920.GA4251@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102300.29411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 9 April 2007 14:39, Pavel Machek wrote:
> Hi!
> 
> > > > Some time ago we discussed the possibility of simplifying the swsusp's approach
> > > > towards tracking the swap pages allocated by it for saving the image (so that
> > > > they can be freed if there's an error).
> > > > 
> > > > I think we can get back to it now, as it is a nice optimization that should
> > > > allow us to use less memory (almost always) and improve performance a bit.
> > > > 
> > > 
> > > Well, I do not think you can measure the difference, but...
> > 
> > As far as the memory usage is concerned, I can. :-)  Usually, it takes 1 extent
> > (40 B on x86_64) to register all of the allocated swap pages.  If bitmaps are
> > used, we need as many bits as there are swap pages available (for 1 GB swap
> > and 4 KB pages that would be ~250000 bits, which gives ~8 pages, and we can
> > save more than 800 extents using that much memory).
> 
> Well... obviously it works for the best case. OTOH, for the worst, it
> needs 40bytes for every 2 bits. That's 16000% worse. And for that
> nightmare-fragmented 1GB swap, you'll need 5000000bytes... which is
> pretty bad.
> 
> OTOH 5MB RAM per 1GB swap is not _too_ bad... so we can do it...

In real-life scenarios you always need to keep free swap space enough for
suspending all the time, which IMO effectively prevents the "totally fragmented
1 GB swap" situation from happening.

Greetings,
Rafael
