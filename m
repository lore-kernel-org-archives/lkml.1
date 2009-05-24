Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZEXRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZEXRaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 13:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZEXRaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 13:30:12 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46589 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZEXRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 13:30:11 -0400
Date: Mon, 25 May 2009 01:22:04 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090524172204.GC4586@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <200905240727.30677.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905240727.30677.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 07:27:27AM -0500, Michael S. Zick wrote:

> *) The difference on the C7-M/CX700 between the -09143 and -09143lk
> I consider significant.

I agree.

> ***) But, keep in mind, just because the system chip set is different,
> there are other unknowns - -
> We can *not* say at the moment that both machines where using the same 
> execution paths - even though the binaries where identical.

yes, of course.

> Also, there where probably different external modules loaded in the
> two runs - not many, mostly things are built-in.
> 
> The truly significant point on the C7-M/CX700 running -09143lk was that
> when the echi-hcd driver got hung in its failure loop, generating a 
> flood of messages - it did not take down or lock the kernel.
> 
> I consider this "forward progress" - it should be possible to build-in
> the lock-dep checkers and get something in the message buffer -
> rather than just have the machine halt.  Its hard to debug a halted
> machine with only a glowing power-on light for feed-back.  ;)

well, if you're not working with notebooks but actual regular mainboard
devices, then you should have a serial console and possibly still have 
magic sysrq or at least some other interesting information on the console.

I personally don't have access to a CX700 based board at the moment, and due to
my travel schedule I won't get that before June 6th.  However, I do have access
to C7-M boards with VX800 and VX855.  However, they don't use the VIA Rhine
Ethernet chip, so if you are triggering the bug with that driver, it is
unlikely to occur there.

Meanwhile, I will inquire what the CPU guys think should happen with regard
to the LOCK prefix.  If their view of the world of what they expect from the
hardware is already different from our assumptions, we can save ourselves
time consuming testing...

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
