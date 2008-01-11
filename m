Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYAKLcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYAKLcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYAKLce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:32:34 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:45785 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754218AbYAKLcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:32:33 -0500
Date: Fri, 11 Jan 2008 22:30:37 +1100
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.15: kernel processes stuck in D state
Message-ID: <20080111113037.GC3940@zip.com.au>
References: <20080111081233.GB3940@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111081233.GB3940@zip.com.au>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 07:12:33PM +1100, CaT wrote:
> I recently upgraded from an amd 64bit system to an intel one and changed my 
> kernekl accordingly. Everything's great except this:
> 
> root         6  0.0  0.0     0    0 ?        D<   17:11   0:00 [migration/1]
> root         7  0.0  0.0     0    0 ?        D<   17:11   0:00 [ksoftirqd/1]
> root         8  0.0  0.0     0    0 ?        D<   17:11   0:00 [watchdog/1]
> 
> I've tried various kernel configs and that stays the same, including a 
> constant load of 3. My current kernel config and dmesg is attached
> (compressed as I think the ml limit is 40k).
> 
> Not sure what other info to provide so if anything else would be
> helpful, please shout.

I'm just taking a closer look at things now that I've recovered from
spending a day in a nice, loud server room and things are popping up
that make me wonder if 2.6.22.15 is just too old for this motherboard.

> MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC at: 0xFEE00000
> Processor #0 (Bootup-CPU)
> Processor #1
> I/O APIC #4 at 0xFEC00000.
> Setting APIC routing to flat
> Processors: 2

As it should be. Dual core.

> Booting processor 1/2 APIC 0x1
> Not responding.
> Inquiring remote APIC #1...
> ... APIC #1 ID: failed
> ... APIC #1 VERSION: failed
> ... APIC #1 SPIV: failed
> Brought up 1 CPUs

Ook? Shouldn't that be 2? Infact, /proc/cpuinfo confirms this. I only
have one core up.

> Initializing CPU#1
...
> Kernel panic - not syncing: smp_callin: CPU1 started up but did not get a callout!

Eek! This doesn't look so good.

So I now have a nice, brand new, spiffy motherboard and a dual core
cpu... with one core not in use, a weird panic relating to CPUs and
kernel processes hung in D state. Whee! :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
