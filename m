Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXFXPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXFXPxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXFXPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:52:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36079 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbXFXPwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:52:51 -0400
Date: Sun, 24 Jun 2007 17:52:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070624155214.GA11978@elte.hu>
References: <20070622220202.GA16872@elte.hu> <20070623132418.GA32449@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623132418.GA32449@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Today I had a little time to try CFS again (last time it was -v9!). I 
> ran it on top of 2.6.20.14, and simply tried ocbench again. You 
> remember ? With -v9, I ran 64 processes which all progressed very 
> smoothly. With -v18, it's not the case anymore. When I run 64 
> processes, only 7 of them show smooth rounds, while all the other ones 
> are only updated once a second. Sometimes they only progress by one 
> iteration, sometimes by a full round. Some are even updated once ever 
> 2 seconds, because if I drag an xterm above them and quickly remove 
> it, the xterm leaves a trace there for up to 2 seconds.
> 
> Also, only one of my 2 CPUs is used. I see the rq vary between 1 and 
> 5, with a permanent 50% idle... :
> 
>    procs                      memory      swap          io     system      cpu
>  r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
>  1  0  0      0 874400   7864  90436    0    0     0     0  279  2204 50  0 50
>  3  0  0      0 874408   7864  90436    0    0     0     0  273  2122 50  1 50
>  1  0  0      0 874408   7864  90436    0    0     0     0  253  1660 49  1 50
>  3  0  0      0 874408   7864  90436    0    0     0     0  252  1977 50  0 50
>  2  0  0      0 874408   7864  90436    0    0     0     0  253  2274 49  1 50
>  3  0  0      0 874408   7864  90436    0    0     0     0  252  1846 49  1 50
>  1  0  0      0 874408   7864  90436    0    0     0     0  339  1782 49  1 50
> 
> I have no idea about what version brought that unexpected behaviour, 
> but it's clearly something which needs to be tracked down.

hm, the two problems might be related. Could you try v17 perhaps? In v18 
i have 'unified' all the sched.c's between the various kernel releases, 
maybe that brought in something unexpected on 2.6.20.14. (perhaps try 
v2.6.21.5 based cfs too?)

> My scheduler is at 250 Hz, and here are the values I found in 
> /proc/sys/kernel:

could you send me the file the cfs-debug-info.sh script produced. You 
can pick the script up from:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

(i'd suggest to send it in private mail, output is large and detailed. 
If your kernel has no /proc/config.gz then please send me your .config 
file too.)

	Ingo
