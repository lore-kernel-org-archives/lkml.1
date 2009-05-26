Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZEZA1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZEZA1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZEZA0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:26:52 -0400
Received: from mail.crca.org.au ([67.207.131.56]:60470 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZEZA0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:26:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200905260029.25847.oliver@neukum.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090525123228.GA13446@elf.ucw.cz>
	 <1243287557.16743.114.camel@nigel-laptop>
	 <200905260029.25847.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:28:28 +1000
Message-Id: <1243297708.16743.149.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2009-05-26 at 00:29 +0200, Oliver Neukum wrote:
> Am Montag, 25. Mai 2009 23:39:17 schrieb Nigel Cunningham:
> > > If there's not enough swap available, swsusp should freeze, realize
> > > there's no swap, unfreeze and continue. I do not see reliability
> > > problem there.
> >
> > If there's not enough storage available (I'm also thinking of the file
> > allocator Oliver wants), freeing some memory may get you in a position
> 
> No, I do want a dedicated partition. Going to a filesystem is just hiding
> the problem. Filesystems can return -ENOSPC.
> I also want my sytem to reliably hibernate if the filesystem to hold
> the image happens to be remounted ro or to be undergoing a filesystem
> check.
> 
> For full reliability you simply need a reservation. In addition that's
> the fastest solution, too. A simple linear write to an unfragmented
> area.
> The typical system today has three orders of magnitude more disk
> than ram. Do you really have a sytem you want to hibernate that has
> less than 2two orders of magnitude more disk than ram?

I agree that a dedicated non-swap partition has advantages. The only
disadvantage I can think of is resizing it if you buy more RAM (and
since that's not going to happen often, it's not a biggie).

I'm not sure that going to a filesystem is hiding the problem though -
whatever solution you adopt, there can be situations in which space
available < space needed. Dedicated non-swap certainly has the least
difficulties, but least != none.

I want flexibility, because different people have different situations
and needs. You might care about a dedicated partition. Another person
might be putting their toe in the Linux water, dual booting with 80% of
the HDD in M$ and having insufficient space to shuffle Linux data around
to make the partition.

Read only filesystems aren't a problem, by the way. So long as you can
bmap the file, that's enough for TuxOnIce - it doesn't currently expand
files - just bmaps and writes directly to the blocks (not via the fs
layer). That's simpler because you _have_ to do the same approach in
reverse at resume time.

Regards,

Nigel

