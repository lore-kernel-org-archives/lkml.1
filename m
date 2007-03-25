Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXCYTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXCYTYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXCYTYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:24:24 -0400
Received: from tapsys.com ([72.36.178.242]:39681 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXCYTYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:24:22 -0400
Message-ID: <4606CC62.6000006@madrabbit.org>
Date: Sun, 25 Mar 2007 12:24:18 -0700
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to itself
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323184828.GP752@stusta.de> <46046D6D.3030202@madrabbit.org> <20070324191112.GA1626@elte.hu>
In-Reply-To: <20070324191112.GA1626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ray Lee <ray-lk@madrabbit.org> wrote:
> 
>> Subject: [PATCH] x86_64: avoid sending LOCAL_TIMER_VECTOR IPI to 
>> itself
>>
>> Ray Lee reported, that on an UP kernel with "noapic" command line 
>> option set, the box locks hard during boot.
> 
> i think this bug deserves a bit more attention, because similar problems 
> could be in other codepaths too.
> 
> the problem here is that we tried to send an IPI to ourselves - which 
> confused Ray's system which has an IO-APIC, but where due to noapic we 
> keep the IO-APIC in its BIOS default.
> 
> this isnt a new problem: the new time code just exposed it more 
> prominently that it was visible before. (the SMP kernel probably would 
> hang in a similar way on Ray's system)

Taking the hint, yes it does. (I'd never had a reason to test it before.)
Booting an SMP kernel without NOAPIC works, with NOAPIC hangs fairly early
on, implying a real fix to my problem belongs down at the arch level, I
suppose.

> i dont see any clear debugging in the IPI code that excludes self-IPIs. 
> I think the only valid way to do that is to use DEST_SELF. Andi?

Ray
