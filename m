Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXDGXKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXDGXKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 19:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbXDGXKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 19:10:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49705 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXDGXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 19:10:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@linuxmail.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Date: Sun, 8 Apr 2007 01:13:23 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <200704072320.40238.rjw@sisk.pl> <20070407150612.f99aae4a.akpm@linux-foundation.org> <1175985065.10725.20.camel@nigel.suspend2.net>
In-Reply-To: <1175985065.10725.20.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704080113.24171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 April 2007 00:31, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2007-04-07 at 15:06 -0700, Andrew Morton wrote:
> > On Sat, 7 Apr 2007 23:20:39 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This should allow us to reduce the memory usage, practically always, and
> > > improve performance.
> > 
> > And does it?

Yes.  There are theoretical corner cases in which it may be less efficient
than the current approach, but in the usual situation it is _much_ better.

> It will. I've been using extents for ages, for the same reasons. I don't
> put them in an rb_tree because I view it as less than most efficient,

Actually, I don't agree with that.  In the normal situation (ie. one extent is
needed) there is no difference as far as the memory usage or performance
are concerned, but if there are more extents, the rbtree should be more
efficient.

> but it will still be a huge step forward from bitmaps in the normal
> case.
> 
> The worst case would be if every second page of swap was in use, so that
> you needed one extent per swap page. In that case, it would use more
> memory than the bitmap, but far, far more common will be the case where
> only one extent is needed for the whole swap partition, because the
> algorithm used by the swap allocator minimises fragmentation.

Exactly.

Greetings,
Rafael
