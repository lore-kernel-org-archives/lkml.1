Return-Path: <linux-kernel-owner+w=401wt.eu-S934956AbXGXJjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934956AbXGXJjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762170AbXGXJix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:38:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53927 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812AbXGXJiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:38:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Tue, 24 Jul 2007 11:47:05 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200707232305.12364.nigel@nigel.suspend2.net> <200707240005.22163.rjw@sisk.pl> <200707240827.18807.nigel@nigel.suspend2.net>
In-Reply-To: <200707240827.18807.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241147.05888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 July 2007 00:27, Nigel Cunningham wrote:
> Hi.
> 
> On Tuesday 24 July 2007 08:05:21 Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Monday, 23 July 2007 15:05, Nigel Cunningham wrote:
> > > Hi all.
> > > 
> > > As we all know, pageflags have been a scarce resource for a while now. 
> These 
> > > patches seek to help address that issue by adding support for a new type 
> > > of 'dynamically allocated' pageflag.
> > > 
> > > The basic idea is that we use per node & zone bitmaps built out of order 
> zero 
> > > allocations, to replace bits in page->flags. Bitmaps can be sparse, being 
> > > populated when a bit on the page is set, and returning zero for all bits 
> in 
> > > sparse pages. Untested hotplug support is included.
> > > 
> > > This method of storing the data does of course come with a performance 
> hit. 
> > > I've included some simple timing loops in #ifdef'd code that help quantify 
> > > that.
> > > 
> > > Interestingly, the new implementation is actually quicker under some 
> > > circumstances. In cases where the usage pattern involves operating on the 
> > > flags for a number of pages in succession, the hit involved in getting the 
> > > struct pages from main memory appears to be greater than that involved in 
> > > calculating which unsigned long and bit to test.
> > > 
> > > Tested only on UP (x86_64) so far.
> > 
> > How does it compare to the memory bitmaps used by swsusp, defined in
> > kernel/power/snapshot.c?
> 
> Looking through kernel/power/snapshot.c, I'd say this implementation has 
> advantages in having support for memory hotplugging, sparseness and random 
> access to the flags in the bitmap. Like the snapshot.c implementation, it 
> uses per-zone bitmaps and has a method that can be used to iterate over the 
> contents of a bitmap. Having per-node support might also be useful. I haven't 
> looked at the speed of the snapshot.c implementation.

Well, that's what I'm really interested in.

> Do you see advantages to snapshot.c that I might have missed?

Not at the moment, but I need to have a closer look.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
