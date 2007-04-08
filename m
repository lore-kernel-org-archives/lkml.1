Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXDHQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXDHQ7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXDHQ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:59:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51789 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbXDHQ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:59:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Sun, 8 Apr 2007 19:02:35 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <200704072320.40238.rjw@sisk.pl> <20070408125636.GB4404@ucw.cz>
In-Reply-To: <20070408125636.GB4404@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704081902.35857.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 April 2007 14:56, Pavel Machek wrote:
> Hi!
> 
> > Some time ago we discussed the possibility of simplifying the swsusp's approach
> > towards tracking the swap pages allocated by it for saving the image (so that
> > they can be freed if there's an error).
> > 
> > I think we can get back to it now, as it is a nice optimization that should
> > allow us to use less memory (almost always) and improve performance a bit.
> > 
> 
> Well, I do not think you can measure the difference, but...

As far as the memory usage is concerned, I can. :-)  Usually, it takes 1 extent
(40 B on x86_64) to register all of the allocated swap pages.  If bitmaps are
used, we need as many bits as there are swap pages available (for 1 GB swap
and 4 KB pages that would be ~250000 bits, which gives ~8 pages, and we can
save more than 800 extents using that much memory).

> >  kernel/power/power.h  |   27 +---------
> >  kernel/power/swap.c   |   18 +-----
> >  kernel/power/swsusp.c |  135 ++++++++++++++++++++++++++------------------------
> >  kernel/power/user.c   |   22 +-------
> >  4 files changed, 85 insertions(+), 117 deletions(-)
> 
> ....as it removes code... I think we can do that. But it is 2.6.23+
> material.

Yes, I think so, but still we can ask Andrew to include it into -mm earlier? ;-)

Rafael
