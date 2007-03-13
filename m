Return-Path: <linux-kernel-owner+w=401wt.eu-S1030389AbXCMOaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389AbXCMOaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030405AbXCMOaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:30:30 -0400
Received: from waste.org ([66.93.16.53]:34243 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030389AbXCMOa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:30:29 -0400
Date: Tue, 13 Mar 2007 09:17:18 -0500
From: Matt Mackall <mpm@selenic.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313141718.GE10459@waste.org>
References: <200703111457.17624.kernel@kolivas.org> <200703130549.47058.kernel@kolivas.org> <1173730314.6431.30.camel@Homer.simpson.net> <200703130738.19034.kernel@kolivas.org> <1173732344.6431.54.camel@Homer.simpson.net> <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com> <1173762639.7944.45.camel@Homer.simpson.net> <20070313081805.GA22327@elte.hu> <1173778398.6810.21.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173778398.6810.21.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:33:18AM +0100, Mike Galbraith wrote:
> On Tue, 2007-03-13 at 09:18 +0100, Ingo Molnar wrote:
> 
> > Con, we want RSDL to /improve/ interactivity. Having new scheduler 
> > interactivity logic that behaves /worse/ in the presence of CPU hogs, 
> > which CPU hogs are even reniced to +5, than the current interactivity 
> > code, is i think a non-starter. Could you try to fix this, please? Good 
> > interactivity in the presence of CPU hogs (be them default nice level or 
> > nice +5) is _the_ most important scheduler interactivity metric. 
> > Anything else is really secondary.
> 
> I just retested with the encoders at nice 0, and the x/gforce combo is
> terrible.  Funny thing though, x/gforce isn't as badly affected with a
> kernel build.  Any build is quite noticable, but even at -j8, the effect
> doen't seem to be (very brief test warning applies) as bad as with only
> the two encoders running.  That seems quite odd.

Is gforce calling sched_yield?

Can you try testing with some simpler loads, like these:

memload:
#!/usr/bin/python
a = "a" * 16 * 1024 * 1024
while 1:
    b = a[1:] + "b"
    a = b[1:] + "c"

execload:
#!/bin/sh
exec ./execload

forkload:
#!/bin/sh
./forkload&

pipeload:
#!/usr/bin/python
import os
pi, po = os.pipe()
if os.fork():
  while 1:
    os.write(po, "A" * 4096)
else:
  while 1:
    os.read(pi, 4096)

-- 
Mathematics is the supreme nostalgia of our time.
