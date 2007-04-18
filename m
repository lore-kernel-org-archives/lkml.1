Return-Path: <linux-kernel-owner+w=401wt.eu-S2993039AbXDRTF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993039AbXDRTF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXDRTF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:05:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1542 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993039AbXDRTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:05:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 18 Apr 2007 12:05:20 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Matt Mackall <mpm@selenic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418152355.GU11115@waste.org>
Message-ID: <Pine.LNX.4.64.0704181120480.25880@alien.or.mcafeemobile.com>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de>
 <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Matt Mackall wrote:

> On Wed, Apr 18, 2007 at 07:48:21AM -0700, Linus Torvalds wrote:
> > And "fairness by euid" is probably a hell of a lot easier to do than 
> > trying to figure out the wakeup matrix.
> 
> For the record, you actually don't need to track a whole NxN matrix
> (or do the implied O(n**3) matrix inversion!) to get to the same
> result. You can converge on the same node weightings (ie dynamic
> priorities) by applying a damped function at each transition point
> (directed wakeup, preemption, fork, exit).
> 
> The trouble with any scheme like this is that it needs careful tuning
> of the damping factor to converge rapidly and not oscillate and
> precise numerical attention to the transition functions so that the sum of
> dynamic priorities is conserved.

Doing that inside the boundaries of the time constrains imposed by a 
scheduler, is the interesting part. Given also that the size (and members) 
of it (matrix) is dynamic.
Also, a "wakup matrix" (if the name correctly pictures what it is for) 
would help with latencies and priority inheritance, but not for 
global fairness.
The maniacal fairness focus we're seeing now, is due to the fact the 
mainline can have extremely unfair behaviour under certain conditions. 
IMO fairness, although important, should not be main objective of the 
scheduler rewrite. Simplification and predictability should be on higher 
priority, with interactivity achievements bound to decent fariness 
constraints.




- Davide


