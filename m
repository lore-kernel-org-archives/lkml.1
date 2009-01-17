Return-Path: <linux-kernel-owner+w=401wt.eu-S1765332AbZAQRQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765332AbZAQRQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 12:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762729AbZAQRQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 12:16:14 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:63599 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761658AbZAQRQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 12:16:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAFGecUlMQWt2/2dsb2JhbACBbMpWhXM
Date: Sat, 17 Jan 2009 12:15:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <andrea@suse.de>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090117171556.GA32572@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <c384c5ea0901170850q4c72d8bcpc76eb635950aaa2e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <c384c5ea0901170850q4c72d8bcpc76eb635950aaa2e@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:11:28 up 16 days, 17:09,  3 users,  load average: 0.72, 0.46,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Leon Woestenberg (leon.woestenberg@gmail.com) wrote:
> Hello Mathieu et al,
> 
> On Sat, Jan 17, 2009 at 5:26 PM, Mathieu Desnoyers
> <mathieu.desnoyers@polymtl.ca> wrote:
> > A long standing I/O regression (since 2.6.18, still there today) has hit
> > Slashdot recently :
> > http://bugzilla.kernel.org/show_bug.cgi?id=12309
> 
> Are you sure you are solving the *actual* problem?
> 
> The bugzilla entry shows a bisect attempt that leads to a patch
> involving negative clock jumps.
> http://bugzilla.kernel.org/show_bug.cgi?id=12309#c29
> 
> with a corrected link to the bisect patch:
> http://bugzilla.kernel.org/show_bug.cgi?id=12309#c30
> 
> Wouldn't a negative clock jump be very influential to the
> (time-driven) I/O schedulers and be a more probable cause?
> 

When a merge is done, the lowest timestamp between the existing request
and the new request to merge is kept as a start_time value for the
merged request we end up with. In this case, that would probably make
that request stay on top of the queue even if unrelated interactive I/O
requests come.

I suspect that this negative clock jump could have hidden the problem by
making the start time of the interactive request lower than the start
time of the merged request.

Mathieu

> Regards,
> -- 
> Leon
> 
> p.s. Added Thomas to the CC list as his name is on the patch Signed-off-by list.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
