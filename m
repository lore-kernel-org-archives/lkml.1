Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYAJM5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYAJM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYAJM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:57:45 -0500
Received: from brick.kernel.dk ([87.55.233.238]:13026 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbYAJM5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:57:44 -0500
Date: Thu, 10 Jan 2008 13:57:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110125740.GY6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080109231628.GB4039@agk.fab.redhat.com> <20080110083130.GP6258@kernel.dk> <20080110074738.6be1c1ad@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110074738.6be1c1ad@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Chris Mason wrote:
> On Thu, 10 Jan 2008 09:31:31 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Jan 09 2008, Alasdair G Kergon wrote:
> > > Here's the latest version of dm-loop, for comparison.
> > > 
> > > To try it out, 
> > >   ln -s dmsetup dmlosetup
> > > and supply similar basic parameters to losetup.
> > > (using dmsetup version 1.02.11 or higher)
> > 
> > Why oh why does dm always insist to reinvent everything? That's bad
> > enough in itself, but on top of that most of the extra stuff ends up
> > being essentially unmaintained.
> 
> I don't quite get how the dm version is reinventing things.  They use

Things like raid, now file mapping functionality. I'm sure there are
more examples, it's how dm was always developed probably originating
back to when they developed mostly out of tree. And I think it's a bad
idea, we don't want duplicate functionality. If something is wrong with
loop, fix it, don't write dm-loop.

> the dmsetup command that they use for everything else and provide a
> small and fairly clean module for bio specific loop instead of piling
> it onto loop.c....

If loop.c is a problem, I'd rather see a newloop.c (with a better name,
of course) that we can transition to.

> Their code doesn't have the fancy hole handling that yours does, but
> neither did yours 4 days ago ;)

Well mine didn't exist 4 days ago, I was just listing missing
functionality.

> 
> > 
> > If we instead improve loop, everyone wins.
> > 
> > Sorry to sound a bit harsh, but sometimes it doesn't hurt to think a
> > bit outside your own sandbox.
> > 
> 
> It is a natural fit in either place, as both loop and dm have a good
> infrastructure for it.  I'm not picky about where it ends up, but dm
> wouldn't be a bad place.

I know that's your opinion, I reserve the right to have my own on where
this functionality belongs :)

-- 
Jens Axboe

