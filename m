Return-Path: <linux-kernel-owner+w=401wt.eu-S1763088AbYDQJ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763088AbYDQJ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbYDQJ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:28:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934AbYDQJ17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:27:59 -0400
Date: Thu, 17 Apr 2008 11:27:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417092751.GX12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it> <20080417083047.GV12774@kernel.dk> <4807173E.4060300@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4807173E.4060300@unimore.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Paolo Valente wrote:
> Jens Axboe ha scritto:
> >
> >
> >I was thinking about that too. Generally I've been opposed to doing
> >scheduling decisions on anything but time, since that is always
> >relevant. When to hand out slices and to what process, that algorithm is
> >really basic in CFQ and could do with an improvement.
> >
> >  
> Maybe there is also another middle-ground solution. I'll try to sketch 
> it out:
> . use sectors instead of time
> . impose a penalty to each thread in proportion to the distance between 
> its disk requests
> . reduce the maximum budget of each thread as a function of this seek 
> penalty so as to prevent the thread from stealing more than a given time 
> slice (the simple mechanism to limit per-thread budget is already 
> implemented in bfq).
> 
> By doing so, both fairness and time isolation should be guaranteed.
> Finally, this policy should be safe in that, given the maximum time used 
> by a seeky thread to consume its maximum budget on a reference disk, the 
> time used on any faster disk should be shorter.
> 
> Does it seem reasonable?

Not for CFQ, that will stay time based. The problem with #2 above is
that it then quickly turns to various heuristics, which is just
impossible to tune for general behaviour. Or it just falls apart for
other real life situations.

-- 
Jens Axboe

