Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbXK0JVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbXK0JVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbXK0JVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:21:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:50708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbXK0JVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vi9f5qcKXumhlSmDRCLSjPiVTBIRIY9Mv4LIdw7pJmlUql4//qaBt8zApCE1FfjqPL/Q52XNrAogdbfoLjM84kmiNDtwcisvYPiMQckrYolZlQyONLmJEb5S3xHOYu2Yv5RvBbIj+KnHTKxfM0o+qwD3j6j59zhb/mHsLceRYJs=
Message-ID: <b647ffbd0711270121v691ec06bjf62166c83929d844@mail.gmail.com>
Date: Tue, 27 Nov 2007 10:21:12 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071126194412.GC21266@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071117010352.GA13666@vmware.com>
	 <20071119185116.GA28173@vmware.com>
	 <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
	 <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu>
	 <20071120180643.GD4736@vmware.com>
	 <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com>
	 <20071122074652.GA6502@vmware.com>
	 <b647ffbd0711220453i15e786ubbb02c3431869048@mail.gmail.com>
	 <20071126194412.GC21266@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/2007, Micah Dowty <micah@vmware.com> wrote:
>
> The application doesn't really depend on the load-balancer's decisions
> per se, it just happens that this behaviour I'm seeing on NUMA systems
> is extremely bad for performance.
>
> In this context, the application is a virtual machine runtime which is
> executing either an SMP VM or it's executing a guest which has a
> virtual GPU. In either case, there are at least three threads:
>
>   - Two virtual CPU/GPU threads, which are nice(0) and often CPU-bound
>   - A low-latency event handling thread, at nice(-10)
>
> The event handling thread performs periodic tasks like delivering
> timer interrupts and completing I/O operations.

Are I/O operations initiated by these "virtual CPU/GPU threads"?

If so, would it make sense to have per-CPU event handling threads
(instead of one global)? They would handle I/O operations initiated
from their respective CPUs to (hopefully) achieve better data locality
(esp. if the most part of the involved data is per-CPU).

Then let the load balancer to evenly distribute the "virtual CPU/GPU
threads" or even (at least, as an experiment) fix them to different
CPUs as well?

sure, the scenario is highly dependent on a nature of those
'events'... and I can just speculate here :-) (but I'd imagine
situations when such a scenario would scale better).


>
> Thank you again,
> --Micah
>

-- 
Best regards,
Dmitry Adamushko
