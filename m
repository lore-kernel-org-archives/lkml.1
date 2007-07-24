Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXGXTXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXGXTXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbXGXTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:23:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbXGXTXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:23:01 -0400
Message-ID: <46A65190.8070600@redhat.com>
Date: Tue, 24 Jul 2007 15:22:56 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Aaron Porter <atporter@primate.net>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
References: <20070724172513.GB24543@primate.net> <p73vec9sknz.fsf@bingen.suse.de> <20070724184908.GD24543@primate.net>
In-Reply-To: <20070724184908.GD24543@primate.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Porter wrote:
> On Tue, Jul 24, 2007 at 08:48:00PM +0200, Andi Kleen wrote:
>> Aaron Porter <atporter@primate.net> writes:
>>
>>> 	I'm in the process up upgrading a pool of apache servers from
>>> 2.6.17.8 to 2.6.21.5, and we're seeing a pretty major change in behavior.
>>> Under identical network load, 2.6.21 has a load average more than 3 times
>>> higher, cpu 0 spends well over 90% of its time in interrupts (vs ~30%
>>> under 2.6.17). When we hit 3k apache sessions, ksoftirqd eats 100% of cpu0
>>> and our network traffic drops off rapidly. The end result is that 2.6.17
>>> performs twice as well under this load.
>> Can you oprofile it?
> 
> # opreport -l
> CPU: AMD64 processors, speed 1994.52 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
> samples  %        app name                 symbol name
> 914379   48.8404  vmlinux-2.6.21.5         check_poison_obj
> 341920   18.2632  vmlinux-2.6.21.5         poison_obj

I bet you have CONFIG_DEBUG_SLAB turned off in your 2.6.17 kernel, and turned on 
in your 2.6.21 kernel.

	-- Chris
