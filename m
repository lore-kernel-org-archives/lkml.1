Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbXGIEgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbXGIEgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXGIEg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:36:26 -0400
Received: from alnrmhc15.comcast.net ([206.18.177.55]:43069 "EHLO
	alnrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXGIEgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:36:25 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>
	<4691B9A5.6060203@yahoo.com.au>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 00:36:23 -0400
In-Reply-To: <4691B9A5.6060203@yahoo.com.au> (Nick Piggin's message of "Mon\,
	09 Jul 2007 14\:29\:25 +1000")
Message-ID: <87k5taw5vc.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Jeremy Maitin-Shepard wrote:
>> Al Boldi <a1426z@gawab.com> writes:
>> 
>> 
>>> Pavel Machek wrote:
>>> 
>>>> We are stuck with refrigerator for now, and at least for hibernation,
>>>> I don't see any feasible alternative.
>> 
>> 
>>> Feasible alternative?
>> 
>> 
>> I posted such an alternative to the list a short time ago: hibenrating
>> from a *new* kernel space/user space that is created by loading a new
>> kernel in a manner similar to what is done for kexec crashdumps.  Unlike
>> kexec crashdumps, however, it would not require reserving any memory at
>> boot, because the necessary memory (maybe 16MB or 64MB) can be freed
>> just before hibernating, and device drivers can be properly stopped so
>> that DMAs don't stomp over certain memory.

> This is the Morton method, isn't it? :) I remember it sounding like a
> very good idea when he brought it up, but I can't remember the details
> of why it was rejected or what the problems were.

Perhaps he did bring it up before I did.  Please forward me a link to
the thread or other reference if you can find it, as I'd be interested
in reading it.


>> This approach eliminates the need for the freezer, as it would make
>> hibernate look a lot a bit like suspend to ram from the perspective of
>> the "old" kernel (the kernel being hibernated), as the hibernate
>> operation itself would be completely atomic from the perspective of the
>> "old" kernel.  That is not to say, of course, that any code paths would
>> actually be shared, or that the drivers would do the same things
>> (because they probably would not).

> Well it basically is suspend to RAM with the additional step that a
> new kernel gets booted and writes out the data from RAM to disk then
> shuts down.

There is the key difference, though, that the drivers should do rather
different things.  In particular, rather than place the hardware in a
low-power mode, it should place it in some state such that the new
kernel being loaded can handle it.

> I suspect that freeing memory on the fly for the new kernel
> would be non-trivial (but possible), however simply having a reserve
> RAM region for the new kernel would be fine for a first step.

Freeing memory on the fly should be extremely easy for the kernel (this
is precisely what it does when it needs to satisfy an allocation).  Note
that the memory allocated need not be contiguous.

-- 
Jeremy Maitin-Shepard
