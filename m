Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbYDQKVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbYDQKVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYDQKVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:21:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9722 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYDQKVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:21:14 -0400
Date: Thu, 17 Apr 2008 12:21:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: Paolo Valente <paolo.valente@unimore.it>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417102109.GZ12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <4807173E.4060300@unimore.it> <20080417092751.GX12774@kernel.dk> <48072421.60307@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48072421.60307@cse.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Aaron Carroll wrote:
> Jens Axboe wrote:
> >>Maybe there is also another middle-ground solution. I'll try to sketch 
> >>it out:
> >>. use sectors instead of time
> >>. impose a penalty to each thread in proportion to the distance between 
> >>its disk requests
> >>. reduce the maximum budget of each thread as a function of this seek 
> >>penalty so as to prevent the thread from stealing more than a given time 
> >>slice (the simple mechanism to limit per-thread budget is already 
> >>implemented in bfq).
> >>
> >>By doing so, both fairness and time isolation should be guaranteed.
> >>Finally, this policy should be safe in that, given the maximum time used 
> >>by a seeky thread to consume its maximum budget on a reference disk, the 
> >>time used on any faster disk should be shorter.
> >>
> >>Does it seem reasonable?
> >
> >Not for CFQ, that will stay time based. The problem with #2 above is
> >that it then quickly turns to various heuristics, which is just
> >impossible to tune for general behaviour. Or it just falls apart for
> >other real life situations.
> 
> Like SSD or hardware RAID.  Time-slices have the nice property of fairness
> irrespective of the underlying hardware characteristics.

Exactly. We can cater to that somewhat by adding some simple hardware
profiles, so that the IO schedulers if seeks etc are costly or not. But
it's a good example none the less.

-- 
Jens Axboe

