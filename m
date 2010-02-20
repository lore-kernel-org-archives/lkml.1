Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0BTHm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:42:58 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:59080 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0BTHm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EOxSgcUUccA3DL1rsv98z/q/6zIzcs4G3gSJFShQk1mz6HaJuz/7CaVFTH85hHgqsm
         YRd40Q5LzclIAUb+rATNMFdv6FTE6829fK5bx3yTic4alZgqG62r/mOlQCBVbHH5k//8
         l7/gRZE8w/O1w+UAsMiuqEBVbirKOBMtY2do8=
MIME-Version: 1.0
In-Reply-To: <1266518735.3829.4.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
Date: Sat, 20 Feb 2010 15:42:56 +0800
Message-ID: <a8e1da1002192342x7ca67176ta285db35ec6d34a6@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Dave Young <hidave.darkstar@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 2:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-02-18 at 08:31 -0800, Linus Torvalds wrote:
>
>> > > halt/4071 is trying to acquire lock:
>> > >  (s_active){++++.+}, at: [<c0000000001ef868>]
>> > > .sysfs_addrm_finish+0x58/0xc0
>> > >
>> > > but task is already holding lock:
>> > >  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at:
>> [<c0000000004cd6ac>]
>> > > .lock_policy_rwsem_write+0x84/0xf4
>> > >
>> > > which lock already depends on the new lock.
>>
>> You don't have a full backtrace for these things?
>
> No, it deadlocks right there, unfortunately.
>
>> We've had lots of trouble with the cpu governors, and I suspect the
>> problem isn't new, but the lockdep warning is likely new (see commit
>> 846f99749ab68bbc7f75c74fec305de675b1a1bf: "sysfs: Add lockdep
>> annotations
>> for the sysfs active reference").
>>
>> So it is likely to be an old issue that (a) now gets warned about and
>> (b) might have had timing changes enough to trigger it.
>
> Well, it used to not deadlock and actually shut down the machine :) So
> in that sense it's definitely new. It might have printed a lockdep
> warning before, which you wouldn't normally see since the machine turns
> off right after this.

before shutdown, you can:
echo N > /proc/sys/kernel/printk_delay
to see the printk messages, N is 0-10000 in milliseconds

>
>> I suspect it is G5-specific (or specific to whatever CPU frequency
>> code
>> that gets used there), since I think we'd have had lots of reports if
>> this
>> happened on x86.
>
> Yeah, that's puzzling me as well.
>
> johannes
>



-- 
Regards
dave
