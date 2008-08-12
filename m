Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYHLWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYHLWNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYHLWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:13:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60272 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbYHLWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:13:07 -0400
Date: Tue, 12 Aug 2008 22:55:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Pavel Machek <pavel@suse.cz>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080812225536.191255f0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812181126.GA30061@linux-os.sc.intel.com>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	<7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com>
	<20080809125447.GA13169@ucw.cz>
	<20080811173526.GA28661@linux-os.sc.intel.com>
	<20080812120031.GD8806@elf.ucw.cz>
	<20080812181126.GA30061@linux-os.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead a rounded timer after 5 seconds still ensures atleast 1s idle time on
> the CPU without the overhead.
> 
> There can be many users who really don't care about the deadline or can happliy
> use rounded timers or deferrable timers. Say garbage collectors, cache_reap
> and friends, ondemand governor, vga cursor blinking comes to my mind.

The cursor really really needs to be steady to within a few frames or you
will notice it. Not using blinking cursors would of course be even better
(or sneaking the blink into the graphics hardware ;))

Your API also needs to use some kind of internal time concept that can be
shared between virtual machines because the end product of this done
right has to be to push timer scheduling at the basic level into the
hypervisor because it needs to merge timer events across guests. Anything
less and your get screwed the moment you load 50 guests on your box.

The simplest I can see to do it would be to make init_timer set a timer
field for tolerance to zero. Existing stuff would just work and new
drivers can set timer.tolerance = foo;

powertop can then be use to hit the key wakeup causes in the existing code

Alan
