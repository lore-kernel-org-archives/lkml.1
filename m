Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYLHFZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYLHFZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 00:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYLHFZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 00:25:15 -0500
Received: from main.gmane.org ([80.91.229.2]:59645 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYLHFZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 00:25:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IO space memcpy support for userspace.
Date: Sun, 07 Dec 2008 23:24:58 -0600
Message-ID: <493CAFAA.6010107@shaw.ca>
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>	 <119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>	 <20081205.122238.12303228.davem@davemloft.net>	 <21d7e9970812052234u58586957y83d618eea295e0f7@mail.gmail.com> <119aab440812060807i8ca0583pdf9aa3b15bdc54fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <119aab440812060807i8ca0583pdf9aa3b15bdc54fd@mail.gmail.com>
Cc: libc-alpha@sources.redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos O'Donell wrote:
> On Sat, Dec 6, 2008 at 1:34 AM, Dave Airlie <airlied@gmail.com> wrote:
>> Its a real pain in the ass with dynamic buffer objects, we don't want userspace
>> to care where they are located, the kernel migrates them in/out of
>> video memory, GART, local RAM etc.
>>
>> However I suspect I just need on these platforms to ban any CPU
>> accesses to pixmaps in VRAM. However
>> sw fallbacks to the front buffer will always need these accesses.
>>
>> Its going to be a real pain getting any traction this stuff upstream
>> (X.org/Mesa) where the world is x86 and maybe the odd powerpc, having
>> to do special accessors for shithouse hw is never going to be fun.
> 
> Is there no case on x86 when this matters?
> 
> What about ARM, ColdFire or MIPS?

On x86, assuming the kernel hasn't done stupid things like map memory 
ranges with conflicting memory types, etc. then no, it doesn't matter 
what instructions you use to beat on the memory range, which is as it 
should be. If this IA64 case is as described by Dave this really sounds 
like a case of a brain damaged platform IMHO.. having memory-mapped 
ranges where using certain instructions to write to them locks the 
machine is just ridiculous. This sounds like one of those cases where a 
hardware designer pawns off a particular case as "software can deal with 
it" and causes the software people 10 times as much aggravation as they 
saved themselves..

> 
> As the embedded market continues to grow I hope to see X.org/Mesa on
> more hardware with different memory access rules.
> 
> Cheers,
> Carlos.

