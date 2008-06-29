Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYF2XVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYF2XVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYF2XVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:21:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYF2XVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:21:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Date: Mon, 30 Jun 2008 01:22:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: xfs-masters@oss.sgi.com, Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <4744FD87.7010301@goop.org> <20080626150910.GK5642@ucw.cz> <20080629221217.GM29319@disturbed>
In-Reply-To: <20080629221217.GM29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806300122.48204.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 of June 2008, Dave Chinner wrote:
> On Thu, Jun 26, 2008 at 05:09:10PM +0200, Pavel Machek wrote:
> > > > Is this the same thing the per-device IO-queue-freeze patches for
> > > >HDAPS also
> > > > need to do?  If so, you may want to talk to Elias Oltmanns
> > > > <eo@nebensachen.de> about it.  Added to CC.
> > > 
> > > Thanks for the heads up Henrique. Even though these issues seem to be
> > > related up to a certain degree, there probably are some important
> > > differences. When suspending a system, the emphasis is on leaving the
> > > system in a consistent state (think of journalled file systems), whereas
> > > disk shock protection is mainly concerned with stopping I/O as soon as
> > > possible. As yet, I cannot possibly say to what extend these two
> > > concepts can be reconciled in the sense of sharing some common code.
> > 
> > Actually, I believe requirements are same.
> > 
> > 'don't do i/o in dangerous period'.
> > 
> > swsusp will just do sync() before entering dangerous period. That
> > provides consistent-enough state...
> 
> As I've said many times before - if the requirement is "don't do
> I/O" then you have to freeze the filesystem. In no way does 'sync'
> prevent filesystems from doing I/O.....

Well, it seems we can handle this on the block layer level, by temporarily
replacing the elevator with something that will selectively prevent fs I/O
from reaching the layers below it.

I talked with Jens about it on a very general level, but it seems doable at
first sight.

Thanks,
Rafael
