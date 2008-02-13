Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbYBMDdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbYBMDdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYBMDdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:33:36 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:46413 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYBMDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:33:35 -0500
Message-ID: <47B264E3.4090605@qualcomm.com>
Date: Tue, 12 Feb 2008 19:32:51 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, pj@sgi.com, a.p.zijlstra@chello.nl, gregkh@suse.de,
       rusty@rustcorp.com.au
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
References: <47B11C45.6060408@qualcomm.com>	<200802121741.22201.nickpiggin@yahoo.com.au> <20080211.224436.174153780.davem@davemloft.net>
In-Reply-To: <20080211.224436.174153780.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Tue, 12 Feb 2008 17:41:21 +1100
> 
>> stop machine is used for more than just module loading and unloading.
>> I don't think you can just disable it.
> 
> Right, in particular it is used for CPU hotplug.
Ooops. Totally missed that. And a bunch of other places.

[maxk@duo2 cpuisol-2.6.git]$ git grep -l stop_machine_run
Documentation/cpu-hotplug.txt
arch/s390/kernel/kprobes.c
drivers/char/hw_random/intel-rng.c
include/linux/stop_machine.h
kernel/cpu.c
kernel/module.c
kernel/stop_machine.c
mm/page_alloc.c

I wonder why I did not see any issues when I disabled stop machine completely.
I mentioned in the other thread that I commented out the part that actually halts
the machine and ran it for several hours on my dual core laptop and on the quad
core server. Tried all kinds of workloads, which include constant module removal
and insertion, and cpu hotplug as well. It cannot be just luck :).

Clearly though, you guys are right. It cannot be simply disabled. Based on the 
above grep it's needed for CPU hotplug, mem hotplug, kprobes on s390 and intel
rng driver. Hopefully we can avoid it at least in module insertion/removal.

Max



