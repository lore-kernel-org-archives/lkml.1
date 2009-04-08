Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZDHHPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZDHHPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZDHHPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:15:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34390 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZDHHPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:15:24 -0400
Date: Wed, 8 Apr 2009 09:15:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Justin Madru <jdm64@gawab.com>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090408071522.GS5178@kernel.dk>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <20090408065201.GA6490@elte.hu> <20090408065352.GR5178@kernel.dk> <20090408071102.GB22868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408071102.GB22868@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Apr 08 2009, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > I too have an async hang/crash, on an old-style SCSI (aic7xxx) box 
> > > > - hang log attached below.
> > > > [...]
> > > >
> > > > ( Full bootlog attached below as well - i'm sending the config as a 
> > > >   reply as this mail is close to lkml size limits already. )
> > > 
> > > Config attached.
> > > 
> > >  known bad  : v2.6.29-9854-gd508afb
> > >  known good : v2.6.29
> > > 
> > > Suspected commit introducing the regression:
> > > 
> > >  9710794: async: remove the temporary (2.6.29) "async is off by default" code
> > > 
> > > (i'll now try a revert of this.)
> > 
> > That's what I figured was the culprit as well, but that does not 
> > really tell us anything about what part of async.c is buggy :-)
> 
> async.c itself is likely not to be buggy - fundamental bugs that 
> deep in the center of the kernel usually cannot hide for long :-)

While it may not be in async.c, the code a) really isn't that old, and
b) hasn't really been used yet. So I'd definitely not rule out a bug in
the async implementation itself.

> What matters more is the _effects_ of having async bootup now, on 
> various subsystems it interacts with. Unexpected parallelism and 
> reordering between init sequences.
> 
> It would have been far better to not have such a 'flip the switch 
> on' moment - but instead a more gradual step by step introduction of 
> async bootup, with accompanied strong testing.

Definitely, switching on single sub systems/drivers one at the time
would be a much saner approach.

-- 
Jens Axboe

