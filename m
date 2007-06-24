Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXFXRJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXFXRJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXFXRJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:09:13 -0400
Received: from 1wt.eu ([62.212.114.60]:3145 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXFXRJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:09:12 -0400
Date: Sun, 24 Jun 2007 19:08:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070624170802.GA10976@1wt.eu>
References: <20070622220202.GA16872@elte.hu> <20070623132418.GA32449@1wt.eu> <20070624155214.GA11978@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624155214.GA11978@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Jun 24, 2007 at 05:52:14PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Today I had a little time to try CFS again (last time it was -v9!). I 
> > ran it on top of 2.6.20.14, and simply tried ocbench again. You 
> > remember ? With -v9, I ran 64 processes which all progressed very 
> > smoothly. With -v18, it's not the case anymore. When I run 64 
> > processes, only 7 of them show smooth rounds, while all the other ones 
> > are only updated once a second. Sometimes they only progress by one 
> > iteration, sometimes by a full round. Some are even updated once ever 
> > 2 seconds, because if I drag an xterm above them and quickly remove 
> > it, the xterm leaves a trace there for up to 2 seconds.
> > 
> > Also, only one of my 2 CPUs is used. I see the rq vary between 1 and 
> > 5, with a permanent 50% idle... :
> > 
> >    procs                      memory      swap          io     system      cpu
> >  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> >  1  0  0      0 874400   7864  90436    0    0     0     0  279  2204 50  0 50
> >  3  0  0      0 874408   7864  90436    0    0     0     0  273  2122 50  1 50
> >  1  0  0      0 874408   7864  90436    0    0     0     0  253  1660 49  1 50
> >  3  0  0      0 874408   7864  90436    0    0     0     0  252  1977 50  0 50
> >  2  0  0      0 874408   7864  90436    0    0     0     0  253  2274 49  1 50
> >  3  0  0      0 874408   7864  90436    0    0     0     0  252  1846 49  1 50
> >  1  0  0      0 874408   7864  90436    0    0     0     0  339  1782 49  1 50
> > 
> > I have no idea about what version brought that unexpected behaviour, 
> > but it's clearly something which needs to be tracked down.
> 
> hm, the two problems might be related. Could you try v17 perhaps? In v18 
> i have 'unified' all the sched.c's between the various kernel releases, 
> maybe that brought in something unexpected on 2.6.20.14. (perhaps try 
> v2.6.21.5 based cfs too?)

Well, forget this, I'm nuts. I'm sorry, but I did not set any of the -R
and -S parameter on ocbench, which means that all the processes ran at
full speed and did not sleep. The load distribution was not fair, but
since they put a lot of stress on the X server, I think it might be one
of the reasons for the unfairness. I got the same behaviour with -v17,
-v9 and even 2.4 ! It told me something was wrong on my side ;-)

I've retried with 50%/50% run/sleep, and it now works like a charm. It's
perfectly smooth with both small and long run/sleep times (between 1 and 100
ms). I think that with X saturated, it might explain why I only had one CPU
running at 100% !

Next time, I'll try to take a bit more time for such a test.

> could you send me the file the cfs-debug-info.sh script produced. You 
> can pick the script up from:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

OK I got it, but I've not run it since the problem was between the keyboard
and the chair. If you want an output anyway, I can give it a run.

Sorry again for the wrong alert.

regards,
willy

