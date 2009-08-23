Return-Path: <linux-kernel-owner+w=401wt.eu-S1751098AbZHWXUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098AbZHWXUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 19:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZHWXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 19:20:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZHWXUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 19:20:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: What to do?
Date: Mon, 24 Aug 2009 01:20:30 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@lists.tuxonice.net>
References: <4A8CCF95.9030401@crca.org.au> <200908240004.16769.rjw@sisk.pl> <4A91CBB9.1080702@crca.org.au>
In-Reply-To: <4A91CBB9.1080702@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908240120.30776.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009, Nigel Cunningham wrote:
> Hi.

Hi,

> Rafael J. Wysocki wrote:
> > On Sunday 23 August 2009, Jiri Slaby wrote:
> >> On 08/20/2009 06:22 AM, Nigel Cunningham wrote:
> >>> I'd therefore like to ask whether there's anyone out there who could do
> >>> one or more of:
> >>>
> >>> 1) Step up to the plate and help improve swsusp, without relying on any
> >>> help from me but with my blessing if they choose to copy wholesale bits
> >>> of TuxOnIce;
> >> Hi, I think I can help here.
> > 
> > Great, thanks!
> 
> Yes, thanks for volunteering, Jiri!
> 
> We should start by asking where you're at as far as knowledge of swsusp
> and TuxOnIce goes. I know you've been around the TuxOnIce lists a bit,
> but don't know how much you know about C programming or the inards of
> the kernel, swsusp or TuxOnIce (ie how much help do you need to get up
> to speed?).
> 
> >> Is there any TODO or similar resources?
> > 
> > Not that I know of, but I think we should start with the non-controversial
> > things, like image compression etc.
> 
> No, I have a bit of a mental to-do list, but haven't written anything
> down yet. Here's a quick, high-level list (some of these things are big):
> 
> - Rework swap allocation (as per below) and freeing.
> - Rework i/o to use bmapping and lay the foundations for use multiple
> block devices.
> - Add modular design (will simplify the following additions)
> - Add multithreaded I/O
> - Add compression support
> - Add support for multiple swap devices
> - Add support for generic files (file allocator)
> - Do storage allocation etc ('image preparation') prior to the atomic
> copy instead of afterwards, making the only remaining variable how much
> ram drivers' pm routines need (and that might not be an issue by then).
> - Add userspace helper support (storage manager/userui).
> 
> I'd really like to start with adding the modular design - it will make
> things a lot cleaner, but I think we need to do some disentanglement
> first (TuxOnIce has all the support for compression in one file that
> simply isn't compiled if we don't want compression support. It would be
> good to get swsusp set up like that). This is why I have above the
> initial thought of handling doing the swap & compression stuff first.
> 
> When I prepared those compression patches earlier, it became apparent
> that we really need to begin with reworking how the swap is allocated,
> remembered and stored in the image header.
> 
> The current swsusp scheme of having a page of swap addresses preceding
> the pages that are written doesn't work well for compression, because
> when rereading the image, you can only do readahead in batches of that
> size. Everything will have to grind to a halt while we wait for the next
> 'index' page.
> 
> In TuxOnIce, we allocate all of the swap at the start of preparing to
> hibernate, which has other advantages I won't go into now. The pages
> allocated are stored as extents in memory. For doing the actual I/O, we
> bmap the swap that's allocated right after allocating it, storing the
> sector numbers in extents as well (remembering the block sizes that are
> relevant as well). We then use them directly in writing the image,
> storing major and minor numbers, block sizes and the extents in the
> image header for use at resume time.
> 
> I'd suggest that the place to begin would be converting swsusp to use
> this sort of scheme.
> 
> Regarding the non-controversial vs controversial thing, let's not worry
> about that. We should do things in the order that's logical, sensible
> and lays the foundation for the improvements we're planning to have
> follow. If an improvement is really an improvement, it shouldn't be a
> big problem to show that it has technical merits that make it
> worthwhile. As always in Linux, if someone wants to nak something
> without good reason, they'll just end up getting themselves ignored.

Well, if you start from something that people don't like, it may be difficult
to push the rest.

Still, I think Jiri is more than capable of handling that, so more or less
everything that is a clear improvement and doesn't introduce regressions of any
kind will probably work for me.

Thanks,
Rafael
