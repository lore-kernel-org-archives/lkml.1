Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbZGKTDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbZGKTDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 15:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZGKTDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 15:03:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbZGKTDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 15:03:17 -0400
Date: Sat, 11 Jul 2009 21:03:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -tip: block, mm: Fix build error in mm/memcontrol.c
Message-ID: <20090711190303.GB15163@elte.hu>
References: <20090711065152.GA23336@elte.hu> <alpine.LFD.2.01.0907111125030.3552@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907111125030.3552@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 11 Jul 2009, Ingo Molnar wrote:
> > 
> > Today's upstream tree build (x86, 64-bit, allyesconfig) failed 
> > with this build error:
> 
> I merged a better fix from Trond, which should make all of this 
> unnecessary (just move BLK_RW_[A]SYNC to the header file that 
> people need anyway).

ok, that's better. I think if in addition to that we also did what i 
suggested:

> Fix it the simplest way for now, by moving the definitions early 
> in blkdev.h (this cannot break anything), but the real fix would 
> be to split up blkdev.h into blkdev-types.h and blkdev-api.h and 
> make only the API definitions/declarations dependent on 
> CONFIG_BLOCK.

would be one step cleaner.

We could then include blkdev-types.h in backing-dev.h so that it 
picks up the constants. Right now having BLK_RW_[A]SYNC in 
backing-dev.h looks a bit weird. No strong opinion though.

	Ingo
