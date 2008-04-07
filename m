Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbYDGL3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYDGL3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYDGL3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:29:47 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:26414 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYDGL3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:29:46 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
From: Andi Kleen <andi@firstfloor.org>
References: <1207340264.6222.17.camel@localhost.localdomain>
	<200804070255.22516.zippel@linux-m68k.org>
	<alpine.LFD.1.10.0804070826390.3224@apollo.tec.linutronix.de>
Date: Mon, 07 Apr 2008 13:29:44 +0200
In-Reply-To: <alpine.LFD.1.10.0804070826390.3224@apollo.tec.linutronix.de> (Thomas Gleixner's message of "Mon, 7 Apr 2008 08:27:55 +0200 (CEST)")
Message-ID: <873apxsy1j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Apr 2008 11:23:02.0170 (UTC) FILETIME=[BDCF5FA0:01C898A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>  
>> So instead of shooting in the dark, I'd suggest to collect some
>>  numbers first,
>
> That's what we did and John's analysis of the problem is pretty
> correct.

The source of the problem is that RDTSC is not always 100% sync
right?

We debugged a similar problem a long time ago and in that case
it was the CPU speculating around the RDTSC. That was stopped
by adding the CPUIDs to sync the core.

I would double check that the CPUIDs are still executed as needed
on the systems showing the issue.

(the code to turn that on and off is somewhat subtle and breaks occasionally)

Also it was assumed at some point it wasn't needed on P4, but that turned
out to be wrong later. Perhaps the enable logic is still not quite
right.

Or perhaps the CPUIDs need to be moved inside or outside the 
seqlocks?

-Andi
