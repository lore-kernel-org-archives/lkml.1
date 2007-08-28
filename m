Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbXH1EjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbXH1EjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 00:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXH1EjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 00:39:07 -0400
Received: from [212.12.190.95] ([212.12.190.95]:32857 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751366AbXH1EjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 00:39:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Tue, 28 Aug 2007 07:37:53 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
In-Reply-To: <20070827204116.GA12495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708280737.53439.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > Could you try the patch below instead, does this make 3x glxgears
> > > smooth again? (if yes, could you send me your Signed-off-by line as
> > > well.)
> >
> > The task-startup stalling is still there for ~10sec.
> >
> > Can you see the problem on your machine?
>
> nope (i have no framebuffer setup)

No need for framebuffer.  All you need is X using the X.org vesa-driver.  
Then start gears like this:

  # gears & gears & gears &

Then lay them out side by side to see the periodic stallings for ~10sec.

> - but i can see some chew-max
> latencies that occur when new tasks are started up. I _think_ it's
> probably the same problem as yours.

chew-max is great, but it's too accurate in that it exposes any scheduling 
glitches and as such hides the startup glitch within the many glitches it 
exposes.  For example, it fluctuates all over the place using this:

  # for ((i=0;i<9;i++)); do chew-max 60 > /dev/shm/chew$i.log & done

Also, chew-max locks-up when disabling __update_curr, which means that the 
workload of chew-max is different from either the ping-startup loop or the 
gears.  You really should try the gears test by any means, as the problem is 
really pronounced there.

> could you try the patch below (which is the combo patch of my current
> queue), ontop of head 50c46637aa? This makes chew-max behave better
> during task mass-startup here.

Still no improvement.


Thanks!

--
Al

