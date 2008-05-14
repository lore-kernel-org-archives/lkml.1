Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYENG6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYENG6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYENG6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:58:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbYENG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:58:10 -0400
Message-ID: <482A8D7D.7000208@firstfloor.org>
Date: Wed, 14 May 2008 08:58:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?windows-1252?Q?=22S=2E=C7?= =?windows-1252?Q?ag=28lar_Onur=22?= 
	<caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
References: <20080513204206.GA17781@damson.getinternet.no>	<873aol9b73.fsf@basil.nowhere.org>	<19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>	<482A05F3.7020408@firstfloor.org> <20080513210217.59a7ca65@infradead.org>
In-Reply-To: <20080513210217.59a7ca65@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

[cc Len]

> On Tue, 13 May 2008 23:19:47 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Ok the CPU reports it doesn't support any C states in MWAIT. If that
>> is correct then it would be correct to not use MWAIT idle and might
>> actually save more power to not use it.
> 
> what does the current SVN powertop say on this cpu?
> 
>> I don't know if that's true or not. Do you have a power meter perhaps?
>> If yes can you measure if there's a difference between mwait=idle /
>> default on your box when it is idle?
>>
>> [cc Arjan he might now if that CPU is supposed to support C1 in MWAIT]
> 
> I wasn't aware that P4's supported mwait in this way; I thought it was
> core and later.

Not even C1? I generally consider MWAIT without C1 to be unusable.

Anyways if C1 doesn't work then it would be correct to not use MWAIT.
> 
>> CPU reports it supports C1/C2/C3. Are you sure there is a difference
>> on that box? The code should have kept using MWAIT because it checks
>> C1. Please double check.
> 
> The check is .. dubious I suspect... 

I don't think so.

> because the cpuid bits are not
> actually the prime source of information, the BIOS is.

Hmmm? What BIOS information are you refering to?

Normally it's my experience that CPUID is more reliable than the BIOS.

> If the bios says mwait is usable, we need to use it with the values IT
> gives us.

At least to my knowledge the ACPI FADT just says what C states are
available, not if they are implemented with MWAIT or using IO ports.

-Andi



