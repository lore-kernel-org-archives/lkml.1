Return-Path: <linux-kernel-owner+w=401wt.eu-S933656AbYGRASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbYGRASR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933930AbYGRARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:17:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934132AbYGRARB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:17:01 -0400
Date: Fri, 18 Jul 2008 02:16:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080718001640.GA1544@elte.hu>
References: <20080717214222.GA29449@elte.hu> <19f34abd0807171615s5b477d4cr22d3e9444bcf65df@mail.gmail.com> <20080717235254.GA6833@elte.hu> <19f34abd0807171705h31595809y944792ce697bede7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807171705h31595809y944792ce697bede7@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Jul 18, 2008 at 1:52 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >  If only we had some kernel technology that could track and validate
> >  memory accesses, and point out the cases where we access uninitialized
> >  memory, just like Valgrind?
> >
> > ... something like kmemcheck? ;-)
> 
> Cool :)
> 
> > So i booted that box with tip/master and kmemcheck enabled. (plus a few
> > fixlets to make networking allocations be properly tracked by
> > kmemcheck.)
> >
> > It was a slow bootup and long wait, but it gave a few hits here:
> 
> Hm, if you think it was that slow, I am suspecting you were also using 
> SLUB debugging.

nope:

 # CONFIG_SLUB_DEBUG is not set
 CONFIG_SLUB=y

> This can actually be negative, since now SLUB will access the objects 
> (+redzone +padding) and possibly trick kmemcheck into thinking they 
> were initialized in the first place.
> 
> But what we are really looking for is "read from freed memory" 
> messages. So I would actually recommend this: Disable kmemcheck's 
> reporting of uninitialized memory, simply to make it easier to spot 
> the "freed" messages more easily.
> 
> Maybe something like this (warning: whitespace-munged):

ok, applied this too.

> If this only happens during boot, it would also be a good idea to 
> simply reboot the machine a lot...

yeah, i've got a script for that. Will try it overnight.

	Ingo
