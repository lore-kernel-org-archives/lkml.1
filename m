Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0BATou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:44:50 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:60071 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0BATot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:44:49 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 14:44:49 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GYvbxCBN6NpURtuWCSlhxu2bFqX5f6+zChfVgBlCWBJtJya6+T+0vxSaD9pZFWHbKX
         ndUI5VrzL5OSJQ2qJtFxER/E1/gVwWD1CLbJADrjELR8Mux3NHWlRfrwgImHhAql3nId
         r7ulIqEz76NgEC8ZRz5n5bD+TwQZZBbCUGR8A=
Date: Mon, 1 Feb 2010 13:37:35 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: High scheduler wake up times
Message-ID: <20100201193735.GG27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net> <20100130161114.07278221@infradead.org> <20100131003549.GC27390@mediacenter.gateway.2wire.net> <20100130164716.230dfe31@infradead.org> <1265014290.24455.98.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265014290.24455.98.camel@laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 09:51:30AM +0100, Peter Zijlstra wrote:
> Right, aside from that, CFS will only (potentially) delay your wakeup if
> there's someone else on the cpu at the moment of wakeup, and that's
> fully by design, you don't want to fix that, its bad for throughput.
> 
> If you want deterministic wakeup latencies use a RT scheduling class
> (and kernel).

I've confirmed that running my processes as SCHED_FIFO fixes the issue
and allows me to achieve ~999.99 iterations per second.

> As it stand it appears you have at least two bugs in your application,
> you rely on broken epoll behaviour and you have incorrect assumptions on
> what the regular scheduler class will guarantee you (which is in fact
> nothing other than that your application will at one point in the future
> receive some service, per posix).

Interestingly I can also achieve ~999.99 iterations per second by using an
infinite epoll timeout, and adding a 1 msec periodic timerfd handle to
the epoll set while still using SCHED_OTHER.

So it seems I have two solutions when using a new kernel so I'm
satisfied.  I'll see if I can clean up my patch to fix the broken epoll
behavior and send it in.

Thanks,
Shawn
