Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZEZApu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZEZApu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZEZApn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:45:43 -0400
Received: from mail.crca.org.au ([67.207.131.56]:59288 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbZEZApn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:45:43 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: david@lang.hm
Cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0905251732310.18053@asgard>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090525123228.GA13446@elf.ucw.cz>
	 <1243287557.16743.114.camel@nigel-laptop>
	 <200905260029.25847.oliver@neukum.org>
	 <alpine.DEB.1.10.0905251732310.18053@asgard>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:47:27 +1000
Message-Id: <1243298847.16743.169.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2009-05-25 at 17:35 -0700, david@lang.hm wrote:
> On Tue, 26 May 2009, Oliver Neukum wrote:
> 
> > Am Montag, 25. Mai 2009 23:39:17 schrieb Nigel Cunningham:
> >>> If there's not enough swap available, swsusp should freeze, realize
> >>> there's no swap, unfreeze and continue. I do not see reliability
> >>> problem there.
> >>
> >> If there's not enough storage available (I'm also thinking of the file
> >> allocator Oliver wants), freeing some memory may get you in a position
> >
> > No, I do want a dedicated partition. Going to a filesystem is just hiding
> > the problem. Filesystems can return -ENOSPC.
> > I also want my sytem to reliably hibernate if the filesystem to hold
> > the image happens to be remounted ro or to be undergoing a filesystem
> > check.
> >
> > For full reliability you simply need a reservation. In addition that's
> > the fastest solution, too. A simple linear write to an unfragmented
> > area.
> > The typical system today has three orders of magnitude more disk
> > than ram. Do you really have a sytem you want to hibernate that has
> > less than 2two orders of magnitude more disk than ram?
> 
> I actually have a couple of systems that have 128G of ram and 144G of 
> disk. and it can't take 3.5" drives (and I don't know if it's SAS 
> backplane can drive SATA drives, if so it can't take many of them) so the 
> 'dives are cheap' answer may not work.
> 
> now, the question of if it makes sense to try and hibernate this system is 
> a very valid one.

It is. I guess you have to ask how long it takes to get your working set
back if you shutdown instead and whether you can spare ~70G of HDD space
(maybe less, perhaps your compression ration will be very good) for the
storage.

What sort of hard drive throughput do you get? If you double that
(allowing for compression), you should have a good approximation (on the
conservative side) of the throughput you'll be able to get hibernating
and resuming (assuming the CPU(s) can compress the data fast enough).

Regards,

Nigel

