Return-Path: <linux-kernel-owner+w=401wt.eu-S1423021AbXDZA0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423021AbXDZA0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423015AbXDZA0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:26:38 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:58504 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1423011AbXDZA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:26:35 -0400
Date: Wed, 25 Apr 2007 16:51:14 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
  hang in atomic copy)
In-Reply-To: <20070426001414.GO17387@elf.ucw.cz>
Message-ID: <Pine.LNX.4.63.0704251644170.8669@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> 
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> 
 <20070425202741.GC17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
  <20070425214420.GG17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
  <20070425235718.66b71f01@the-village.bc.nu> 
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org> 
 <20070425235235.GN17387@elf.ucw.cz>  <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
 <20070426001414.GO17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Pavel Machek wrote:

>>> Now, if the old kernel left DMAs running, it could be overwriting
>>> the data we are copying in.
>>
>> The *thaw* needs to happen with devices quiescent.
>>
>> But that sure doesn't have anythign to do with the "snapshot()" path. In
>> fact, you'll have rebooted the machine in between.
>
> Only the fact that we are currently using same device call during
> snapshot() and during restore(). We obviously could do _5_ device
> calls
>
> (suspend/resume/freeze/quiesce_disable_dma/thaw)
>
> ...but that looks like too many calls to me.
>
>> So what does that have to do with "snapshotting"?
>
> I'm not comfortable with memory I'm copying changing under my hands
> because of some DMA. It just looks like asking for trouble. I _think_
> we can get away with DMA running during snapshot, because driver may
> not assume anything about the DMA result before it got completion
> interrupt, but...

the key is that with STR you don't need to copy the memory (it's staying where 
it is)

for STD you need to copy the memory, and there you halt DMA becouse you need to 
make an atomic snapshot.

David Lang
