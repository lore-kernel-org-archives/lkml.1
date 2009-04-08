Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZDHHLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZDHHLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZDHHLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:11:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbZDHHL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:11:29 -0400
Date: Wed, 8 Apr 2009 09:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Justin Madru <jdm64@gawab.com>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090408071102.GB22868@elte.hu>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk> <20090408064733.GA16984@elte.hu> <20090408065201.GA6490@elte.hu> <20090408065352.GR5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408065352.GR5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Apr 08 2009, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > I too have an async hang/crash, on an old-style SCSI (aic7xxx) box 
> > > - hang log attached below.
> > > [...]
> > >
> > > ( Full bootlog attached below as well - i'm sending the config as a 
> > >   reply as this mail is close to lkml size limits already. )
> > 
> > Config attached.
> > 
> >  known bad  : v2.6.29-9854-gd508afb
> >  known good : v2.6.29
> > 
> > Suspected commit introducing the regression:
> > 
> >  9710794: async: remove the temporary (2.6.29) "async is off by default" code
> > 
> > (i'll now try a revert of this.)
> 
> That's what I figured was the culprit as well, but that does not 
> really tell us anything about what part of async.c is buggy :-)

async.c itself is likely not to be buggy - fundamental bugs that 
deep in the center of the kernel usually cannot hide for long :-)

What matters more is the _effects_ of having async bootup now, on 
various subsystems it interacts with. Unexpected parallelism and 
reordering between init sequences.

It would have been far better to not have such a 'flip the switch 
on' moment - but instead a more gradual step by step introduction of 
async bootup, with accompanied strong testing.

	Ingo
