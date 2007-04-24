Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbXDXEys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbXDXEys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXDXEys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:54:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36379 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbXDXEyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:54:47 -0400
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr, Gene Heskett <gene.heskett@gmail.com>
In-Reply-To: <462D7D8F.7000401@bigpond.net.au>
References: <20070420140457.GA14017@elte.hu>
	 <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
	 <200704220959.34978.kernel@kolivas.org> <87647oblx5.fsf@pps.jussieu.fr>
	 <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
	 <20070423013429.GB25162@wotan.suse.de>
	 <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
	 <20070423191143.GA16849@elte.hu>
	 <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
	 <462D7D8F.7000401@bigpond.net.au>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 23 Apr 2007 21:52:03 -0700
Message-Id: <1177390323.3244.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Within reason, it's not the number of clients that X has that causes its 
> CPU bandwidth use to sky rocket and cause problems.  It's more to to 
> with what type of clients they are.  Most GUIs (even ones that are 
> constantly updating visual data (e.g. gkrellm -- I can open quite a 
> large number of these without increasing X's CPU usage very much)) cause 
> very little load on the X server.  The exceptions to this are the 


there is actually 2 and not just 1 "X server", and they are VERY VERY
different in behavior.

Case 1: Accelerated driver

If X talks to a decent enough card it supports will with acceleration,
it will be very rare for X itself to spend any kind of significant
amount of CPU time, all the really heavy stuff is done in hardware, and
asynchronously at that. A bit of batching will greatly improve system
performance in this case.

Case 2: Unaccelerated VESA

Some drivers in X, especially the VESA and NV drivers (which are quite
common, vesa is used on all hardware without a special driver nowadays),
have no or not enough acceleration to matter for modern desktops. This
means the CPU is doing all the heavy lifting, in the X program. In this
case even a simple "move the window a bit" becomes quite a bit of a CPU
hog already.

The cases are fundamentally different in behavior, because in the first
case, X hardly consumes the time it would get in any scheme, while in
the second case X really is CPU bound and will happily consume any CPU
time it can get.



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

