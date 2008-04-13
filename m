Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYDMTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYDMTdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYDMTd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:33:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYDMTd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:33:28 -0400
Message-ID: <48025F1B.10701@zytor.com>
Date: Sun, 13 Apr 2008 12:29:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Erik Bosman <ejbosman@cs.vu.nl>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
References: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>	<87r6daw2ay.fsf@basil.nowhere.org>	<Pine.GSO.4.56.0804131126080.28138@keg.few.vu.nl> <87prstwvkr.fsf@basil.nowhere.org>
In-Reply-To: <87prstwvkr.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Erik Bosman <ejbosman@cs.vu.nl> writes:
>> I'm using it for deterministic replay.
> 
> Ok that should be in the changelog.
> 
> BTW x86 CPUs are not fully deterministic. e.g. there are a few errata that
> can lead to differing EFLAGS (generally for instructions with undefined flags 
> output) based on random internal pipe line conditions.
> 

I think you have to define "x86 CPUs" more tightly for that.

> There's also RDPMC, but by default the kernel does not enable that
> for ring 3. And if you go for oddities there are the random number
> generator instructions on VIA CPUs which will obviously not 
> be repeatable.

There has been calls for an RDPMC counter which exposes true CPU cycles 
(varying with frequency, as opposed to wall time.)  And anything I/O -- 
including the RNG -- is obviously off.

I think what Erik is trying to do is to make it possible to disable as 
many of these in the kernel as possible; I/O is easy, it's off by 
default; RDTSC and RDPMC can be disabled in the kernel, and I think even 
XSTORE can be disabled.

	-hpa
