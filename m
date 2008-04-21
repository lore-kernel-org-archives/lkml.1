Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYDUPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYDUPDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYDUPD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:03:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:27181 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYDUPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:03:26 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: improve default idle
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHb2k7009676@hera.kernel.org>
	<20080418154333.f2584b1d.akpm@linux-foundation.org>
	<20080421142737.GU9554@elte.hu>
Date: Mon, 21 Apr 2008 17:03:23 +0200
In-Reply-To: <20080421142737.GU9554@elte.hu> (Ingo Molnar's message of "Mon, 21 Apr 2008 16:27:38 +0200")
Message-ID: <87r6cz6yis.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2008 14:56:35.0424 (UTC) FILETIME=[E4E34600:01C8A3BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> sorry, the changelog should be: if a system uses acpi_pm clocksource but 
> default idle method then the overhead of entry/exit measurement is quite 
> noticeable in profiles. The measurement is redundant anyway, as in HLT 
> sched_clock() is still supposed to work fine. (the worst i know of is a 
> slight skew on certain CPUs in HLT)

sched_clock checks for unstable tsc so on all systems which mark
the TSC unstable at boot that will mean fall back to jiffies.

I'm not sure that will really work for them? It will be very imprecise.
Basically most of the time you'll have 0 delta and occasionally
every tick a huge jump.

For 64bit the idea of relying on TSC here is reasonable, but to make the code 
behaviour really match your description you would first need another 
sched_clock which ignores the normal tsc unstable state (the rewritten 
sched_clock for which I posted links a few times recently did that) 

On 32bit it would also need to take care of the few older CPUs
(like VIA C6) where TSC doesn't tick in C1.

-Andi
