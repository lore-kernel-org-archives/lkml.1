Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYHGHqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYHGHqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYHGHpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:45:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45009 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYHGHpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:45:03 -0400
Date: Thu, 7 Aug 2008 09:45:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       John Stoffel <john@stoffel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
Message-ID: <20080807074502.GB16610@atrey.karlin.mff.cuni.cz>
References: <200808012319.05038.alistair@devzero.co.uk> <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com> <18580.48861.657366.629904@stoffel.org> <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com> <18581.6873.353028.695909@stoffel.org> <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com> <20080803231628.1361b75f@lxorguk.ukuu.org.uk> <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com> <20080805182119.75913fa3@lxorguk.ukuu.org.uk> <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae3aa420808061433i3d90c3dcgfb40d953da2941c8@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> I'm game. Care to guide me through?  So: on every write, this
> >> new device mapper module computes a checksum and stores
> >> it somewhere. On every read, it computes a checksum and
> >> compares to the stored value. Easy enough I guess.
> >>
> >> Several hard parts:
> >> -- where to store the checksums?
> >
> > That is the million dollar question - plus you can argue it is the fs
> > that should do it. There is stuff crawling through the standards world to
> > provide a small per block additional info area on disk sectors.
> 
> My objection to fs-layer checksums (e.g. in some user-space
> file system) is that it  doesn't leverage the extra info that RAID
> has.  If a block is bad, RAID can probably fetch another one
> that is good. You can't do this at the file-system level.
> 
> I assume I can layer device-mappers anywhere, right?
> Layering one *underneath* md-raid would allow it to
> reject/discard bad blocks, and then let the raid layer
> try to find a good block somewhere else.
> 
> I assume that a device mapper can alter the number
> of blocks-in to the number of blocks-out; that it doesn't
> have to be 1-1. Then for every 10 sectors of data, it
> would use 11 sectors of storage, one holding the
> checksum.  I'm very naive about how the block layer
> works, so I don't know what snags there might be.

I did something like that long time ago -- with loop, and separate
partition for checksums.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
