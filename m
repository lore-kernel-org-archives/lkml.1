Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbZAOQGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbZAOQGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757868AbZAOQGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:06:10 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38785 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396AbZAOQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:06:07 -0500
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
	sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Jens Axboe <jens.axboe@oracle.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
References: <200901051952.58029.bzolnier@gmail.com>
	 <20090105185428.GS32491@kernel.dk>
	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>
	 <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru>
	 <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com>
	 <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 11:06:01 -0500
Message-Id: <1232035561.5966.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:07 -0500, Greg Freemyer wrote:
> On Thu, Jan 15, 2009 at 12:37 AM, Tejun Heo <htejun@gmail.com> wrote:
> > Hello,
> >
> > James Bottomley wrote:
> >> I'm afraid that's pretty much marketing coolaid.  Rotational storage
> >> will dominate for the forseeable future: just do a simple back of the
> >> envelope calculation:
> >
> > Or just compare prices per byte of memory, flash and rotation disk.
> > They haven't had changed too much during last several years.
> > Secondary storage which is only slightly cheaper than the primary
> > storage doesn't have much chance of flying high and far.
> >
> > Thanks.
> >
> > --
> > tejun
> 
> Have you seen the new pricing Samsung has announced for their 3rd
> generation SSD.  It is about 1/3 of the Intel' SSD price if I recall
> correctly and the performance is approaching Intel's from what I've
> seen.

I think the point Tejun and I are trying to make is that current SSD
pricing is an artefact of the fact that there's currently a world
surplus of flash components and that today SSD production is tiny.  If
SSD production rises, the demand pressure will force flash prices back
to normal (or even above if manufacturers can charge a premium) and
you'll see SSDs priced much higher than rotational storage.

That's not to say that no-one should be buying todays cheap flash
storage ... just a warning that it can't last if SSDs become hugely
popular.

> I've been talking to the OpenHSM (Hierachical Storage Manager) team
> about their project.  They are working on getting the logic in place
> now to move data blocks from one class of storage to another while
> leaving the filesystem itself un-affected from the users perspective.
> 
> http://code.google.com/p/fscops/
> 
> They have a very long way to go with their code/project, but it is
> conceptually similar to the ext4_defrag patch that already exists.
> The big difference is the data block allocation algorithm will have to
> be totally different.
> 
> If and when that get their code done, I would love to have 500 GB of
> SSD teamed with several TB of rotational HDD and have the HSM move my
> files between fast SSD and slow rotational.  I typically know which
> datasets I will be working with heavily, so even a simple user space
> tool that would let me adjust which tier of storage my files were
> sitting on would suffice.

Right, this is the flash cache idea that's been floating around for a
while.  It's even been suggested as a way of avoiding the IDE barrier
flush penalties.  I think Seagate went as far as making hybrid drives
that were a large flash cache backed by rotational storage.

James


