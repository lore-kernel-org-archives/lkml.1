Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYFCV7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYFCV7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758414AbYFCV71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:59:27 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57538 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbYFCV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:59:25 -0400
Date: Tue, 3 Jun 2008 14:58:33 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Matthew Wilcox <matthew@wil.cx>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <20080603213501.GD3549@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0806031444590.3242@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>
 <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
 <20080602072403.GA20222@flint.arm.linux.org.uk> <200806031416.18195.nickpiggin@yahoo.com.au>
 <alpine.LFD.1.10.0806030746190.3473@woody.linux-foundation.org>
 <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp>
 <20080603185541.GB3549@parisc-linux.org> <Pine.LNX.4.64.0806031253180.3242@t2.domain.actdsltmp>
 <20080603213501.GD3549@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Matthew Wilcox wrote:
> On Tue, Jun 03, 2008 at 12:57:56PM -0700, Trent Piepho wrote:
>> On Tue, 3 Jun 2008, Matthew Wilcox wrote:
>>> On Tue, Jun 03, 2008 at 11:47:00AM -0700, Trent Piepho wrote:
>>>> On Tue, 3 Jun 2008, Linus Torvalds wrote:
>>>>> On Tue, 3 Jun 2008, Nick Piggin wrote:
>>>>>>
>>>>>> Linus: on x86, memory operations to wc and wc+ memory are not ordered
>>>>>> with one another, or operations to other memory types (ie. load/load
>>>>>> and store/store reordering is allowed). Also, as you know, store/load
>>>>>> reordering is explicitly allowed as well, which covers all memory
>>>>>> types. So perhaps it is not quite true to say readl/writel is strongly
>>>>>> ordered by default even on x86. You would have to put in some
>>>>>> mfence instructions in them to make it so.
>>>>
>>>> So on x86, these could be re-ordered?
>>>>
>>>> writel(START_OPERATION, CONTROL_REGISTER);
>>>> status = readl(STATUS_REGISTER);
>>>
>>> You wouldn't ask for write-combining memory mapping for control or
>>> status registers.
>>
>> But Nick said, "store/load reordering is explicitly allowed as well, which
>> covers *all* memory types."
>
> Then Nick is confused.  PCI only defines one way to flush posted writes
> to a device -- doing a read from it.  There's no way that reads can
> be allowed to pass writes (unless you've asked for it, like with write
> combining).

But that requirement is for the PCI bridge, isn't it?  It doesn't matter if
the bridge will flush all posted writes before allowing a read if the CPU
decides to give the bridge the read before the write.  A powerpc CPU will
certainly do this if you don't take any steps like telling it the memory is
uncachable and guarded.  I didn't think it was allowed on x86 (except with
WC), but Nick seemed to say it was.
