Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZGCVNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZGCVNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZGCVNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:13:48 -0400
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:44245 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbZGCVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:13:47 -0400
Date: Fri, 3 Jul 2009 17:25:32 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
In-Reply-To: <87bpo1aaaf.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907031719530.17372@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
 <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu>
 <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
 <20090629210206.GB13125@elte.hu> <Pine.LNX.4.64.0907021702380.13747@pianoman.cluster.toy>
 <87bpo1aaaf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Vince Weaver <vince@deater.net> writes:
>>
>> as I said in a previous post, on most x86 chips the instructions_retired
>> counter also includes any hardware interrupts that occur during the
>> process runtime.
>
> On the other hand afaik near all chips have interrupt performance counter
> events.

I guess by "near all" you mean "only AMD"?  The AMD event also has some 
oddities, as it seems to report things like page faults and other things 
that don't really match up with the excess instruction count.  I must 
admit it's been a while since I've looked at that particular counter.

> But the question is of course if it's worth it, the error should
> be really small. Also you could always lose a few cycles occasionally
> in other "random" events, which can happen too.

> 1-2 error in a million doesn't sound like a catastrophic problem.

well, it's basically at least HZ extra instructions per however many 
seconds your benchmark runs, and unfortunately it's non-deterministic 
because it depends on keyboard/network/usb/etc interrupts too that may by 
chance happen while your program is running.

For me, it's the determinism that matters.  Not overhead, not runtime not 
"oh it doesn't matter, it's small".  For a deterministic benchmark I 
want to get as close to the same value every run as possible.  I admit 
it might not be possible to always get the same result, but the 
closter the better.  This might not match up with the way 
kernel-hackers use perf counters, but it is important for the work I am 
doing.

Vince
