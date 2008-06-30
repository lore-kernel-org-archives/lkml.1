Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYF3GMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYF3GMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYF3GMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:12:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYF3GMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:12:22 -0400
Date: Mon, 30 Jun 2008 02:11:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       Elias Oltmanns <eo@nebensachen.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [xfs-masters] Re: freeze vs freezer
Message-ID: <20080630061149.GA352@infradead.org>
References: <4744FD87.7010301@goop.org> <20080626150910.GK5642@ucw.cz> <20080629221217.GM29319@disturbed> <200806300122.48204.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806300122.48204.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 01:22:47AM +0200, Rafael J. Wysocki wrote:
> > > Actually, I believe requirements are same.
> > > 
> > > 'don't do i/o in dangerous period'.
> > > 
> > > swsusp will just do sync() before entering dangerous period. That
> > > provides consistent-enough state...
> > 
> > As I've said many times before - if the requirement is "don't do
> > I/O" then you have to freeze the filesystem. In no way does 'sync'
> > prevent filesystems from doing I/O.....
> 
> Well, it seems we can handle this on the block layer level, by temporarily
> replacing the elevator with something that will selectively prevent fs I/O
> from reaching the layers below it.
> 
> I talked with Jens about it on a very general level, but it seems doable at
> first sight.

Why would you hack the blok layer when we already have a perfectly fine
facility to archive what you want?  freeze_bdev is there exactly for the
purpose to make the filesystem consistant on disk and then freeze all
I/O.
