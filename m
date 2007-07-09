Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXGIEy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXGIEy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbXGIEyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:54:49 -0400
Received: from sccrmhc13.comcast.net ([63.240.77.83]:53067 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXGIEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:54:48 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>
	<4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>
	<4691BD6F.8000809@yahoo.com.au>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 09 Jul 2007 00:54:46 -0400
In-Reply-To: <4691BD6F.8000809@yahoo.com.au> (Nick Piggin's message of "Mon\,
	09 Jul 2007 14\:45\:35 +1000")
Message-ID: <87fy3yw50p.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Jeremy Maitin-Shepard wrote:
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:

>>> This is the Morton method, isn't it? :) I remember it sounding like a
>>> very good idea when he brought it up, but I can't remember the details
>>> of why it was rejected or what the problems were.
>> 
>> 
>> Perhaps he did bring it up before I did.  Please forward me a link to
>> the thread or other reference if you can find it, as I'd be interested
>> in reading it.

> Sent in the next mail.

Thanks.  I've started reading over the thread.

>>> I suspect that freeing memory on the fly for the new kernel
>>> would be non-trivial (but possible), however simply having a reserve
>>> RAM region for the new kernel would be fine for a first step.
>> 
>> 
>> Freeing memory on the fly should be extremely easy for the kernel (this
>> is precisely what it does when it needs to satisfy an allocation).  Note
>> that the memory allocated need not be contiguous.

> Yes, I have a rough idea about how page reclaim works. But I just
> mean it would not be trivial to load the new kernel into physically
> discontiguous memory. Possible of course, but I don't think kexec or
> the setup code could quite cope ATM.

It would indeed be a pain for the new kernel to be loaded and have to
use discontiguous memory.  The trick is, though, that this is not
necessary.  Immediately before jumping to the new kernel, the first X
bytes (where X is the amount of memory the new kernel will get,
typically 16MB or 64MB) of physical memory are backed up into the
arbitrary discontiguous pages that are made available.  This will not
take very long, because copying even 64MB of memory is extremely fast.
Then the new kernel is free to use the first X bytes of contiguous
physical memory.  Problem solved.

-- 
Jeremy Maitin-Shepard
