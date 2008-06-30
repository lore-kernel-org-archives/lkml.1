Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbYF3Uc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbYF3Uc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYF3Ucu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:32:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYF3Uct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:32:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Date: Mon, 30 Jun 2008 22:34:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <200806300122.48204.rjw@sisk.pl> <20080630061149.GA352@infradead.org>
In-Reply-To: <20080630061149.GA352@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806302234.23887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 of June 2008, Christoph Hellwig wrote:
> On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> > > > Actually, I believe requirements are same.
> > > > 
> > > > 'don't do i/o in dangerous period'.
> > > > 
> > > > swsusp will just do sync() before entering dangerous period. That
> > > > provides consistent-enough state...
> > > 
> > > As I've said many times before - if the requirement is "don't do
> > > I/O" then you have to freeze the filesystem. In no way does 'sync'
> > > prevent filesystems from doing I/O.....
> > 
> > Well, it seems we can handle this on the block layer level, by temporarily
> > replacing the elevator with something that will selectively prevent fs I/O
> > from reaching the layers below it.
> > 
> > I talked with Jens about it on a very general level, but it seems doable at
> > first sight.
> 
> Why would you hack the blok layer when we already have a perfectly fine
> facility to archive what you want?  freeze_bdev is there exactly for the
> purpose to make the filesystem consistant on disk and then freeze all
> I/O.

We tried that in the past and it didn't work very well due to some bad
interactions with the md layer that we wanted to stay functional while we
were saving the image.

Also, do all of the supported filesystems implement this feature?
