Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXDRPiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXDRPiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXDRPiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:38:03 -0400
Received: from waste.org ([66.93.16.53]:46857 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXDRPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:38:00 -0400
Date: Wed, 18 Apr 2007 10:23:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418152355.GU11115@waste.org>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 07:48:21AM -0700, Linus Torvalds wrote:
> And "fairness by euid" is probably a hell of a lot easier to do than 
> trying to figure out the wakeup matrix.

For the record, you actually don't need to track a whole NxN matrix
(or do the implied O(n**3) matrix inversion!) to get to the same
result. You can converge on the same node weightings (ie dynamic
priorities) by applying a damped function at each transition point
(directed wakeup, preemption, fork, exit).

The trouble with any scheme like this is that it needs careful tuning
of the damping factor to converge rapidly and not oscillate and
precise numerical attention to the transition functions so that the sum of
dynamic priorities is conserved.

-- 
Mathematics is the supreme nostalgia of our time.
