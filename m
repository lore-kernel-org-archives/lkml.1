Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZGGWpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZGGWpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZGGWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:45:26 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59100 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZGGWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:45:25 -0400
Message-ID: <4A53CFDC.6080005@gmail.com>
Date: Wed, 08 Jul 2009 00:44:44 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Oleg Nesterov <oleg@redhat.com>,
       Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
References: <20090703095659.GA4518@jolsa.lab.eng.brq.redhat.com> <20090703102530.GD32128@elte.hu> <20090703111848.GA10267@jolsa.lab.eng.brq.redhat.com> <20090707101816.GA6619@jolsa.lab.eng.brq.redhat.com> <20090707134601.GB6619@jolsa.lab.eng.brq.redhat.com> <20090707140135.GA5506@Krystal> <20090707143416.GB11704@redhat.com> <20090707150406.GC7124@Krystal> <20090707154440.GA15605@redhat.com> <1246981815.9777.12.camel@twins> <20090707194533.GB13858@Krystal>
In-Reply-To: <20090707194533.GB13858@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 08 Jul 2009 00:44:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers a écrit :
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
>> On Tue, 2009-07-07 at 17:44 +0200, Oleg Nesterov wrote:
>>> On 07/07, Mathieu Desnoyers wrote:
>>>> Actually, thinking about it more, to appropriately support x86, as well
>>>> as powerpc, arm and mips, we would need something like:
>>>>
>>>> read_lock_smp_mb()
>>>>
>>>> Which would be a read_lock with an included memory barrier.
>>> Then we need read_lock_irq_smp_mb, read_lock_irqsave__smp_mb, write_lock_xxx,
>>> otherwise it is not clear why only read_lock() has _smp_mb() version.
>>>
>>> The same for spin_lock_xxx...
>> At which time the smp_mb__{before,after}_{un,}lock become attractive
>> again.
>>
> 
> Then having a new __read_lock() (without acquire semantic) which would
> be required to be followed by a smp__mb_after_lock() would make sense. I
> think this would fit all of x86, powerpc, arm, mips without having to
> create tons of new primitives. Only "simpler" ones that clearly separate
> locking from memory barriers.
> 

Hmm... On x86, read_lock() is :

	lock subl $0x1,(%eax)
	jns   .Lok
	call	__read_lock_failed
.Lok:	ret


What would be __read_lock() ? I cant see how it could *not* use lock prefix
actually and or being cheaper...

