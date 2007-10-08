Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXJHMeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXJHMeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJHMdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:33:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:37360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbXJHMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:33:41 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [3/6] scheduler: Do devirtualization for sched_fair
Date: Mon, 8 Oct 2007 14:32:24 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200710071059.126674000@suse.de> <20071007205956.5C4E71474B@wotan.suse.de> <20071008114234.GC22199@elte.hu>
In-Reply-To: <20071008114234.GC22199@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081432.24776.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> hm, i'm not convinced about this one. It increases the code size a bit 

Tiny bit (<200 bytes) and the wait_for/sleep_on refactor patch in the series
saves over 1K so I should have some room for code size increase. Overall
it will be still considerable smaller.

> and it's a sched.c local hack. If then this should be done on a generic 
> infrastructure level - lots of other code (VFS, networking, etc.) could 
> benefit from it i suspect - and then should be .configurable as well. 

Unfortunately not -- for this to work (especially for inlining) requires to 
#include files implementing the sub calls. Except for the scheduler that 
is pretty uncommon unfortunately. Also the situation regarding which
call target is the common one is typically much less clear than with 
sched_fair / other scheduling classes.

I considered making it generic, but I don't think it would make sense
at the current time.

Also most paths are not as time critical as the scheduler.

> Then the benefit might become measurable too.

It might have been measurable if the context switch was measurable at all.
Unfortunately the lmbench3 lat_ctx test I tired fluctuated by itself
over 50%. Ok I suppose it would be possible to instrument the kernel itself
to measure cycles. Would that convince you?

-Andi
