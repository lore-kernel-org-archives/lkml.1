Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbXGJR07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbXGJR07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXGJR0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:26:50 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:33297 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbXGJR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:26:50 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Al Boldi <a1426z@gawab.com>, Pavel Machek <pavel@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>
	<4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz>
	<200707091830.48074.a1426z@gawab.com> <87hcoduh4k.fsf@jbms.ath.cx>
	<46939E5E.6010305@goop.org>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 10 Jul 2007 13:25:47 -0400
In-Reply-To: <46939E5E.6010305@goop.org> (Jeremy Fitzhardinge's message of
	"Tue\, 10 Jul 2007 07\:57\:34 -0700")
Message-ID: <871wfguq5g.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Jeremy Maitin-Shepard wrote:
>> I don't know a whole lot about xen, but it seems that one issue with
>> this approach is that it requires you run your system under a hypervisor
>> at all times, which may introduce some overhead.
>> 

> No, I don't think that's what Al is proposing.  The kernel-internal interfaces
> we've put in place to make Xen work could be reused to do some of the things
> you're talking about.  In particular, a kernel running under Xen has to be able
> to deal with non-contiguous physical pages, and reusing the same pagetable hooks
> would allow a kexeced kernel to run happily out of any random assortment of
> pages you manage to allocate for it.

I suppose that would be an interesting thing to look into.  Another
possible approach for having the kernel run in non-contiguous memory is
to specify a memmap exactly to the kernel on the command-line, as I
believe is done for the crashdump kernels currently.  It would, of
course, require an extremely long and complicated memmap specification
in general.  I recall reading, though, that even with the relocatable
kernel support, there are still significant alignment requirements for
loading the kernel.  In particular, I seem to recall that it is
necessary to load an x86 kernel at maybe a 16MB boundary, and on other
platforms the alignment requirements may be even more restrictive.  In
addition, I recall that the Linux boot procedure on x86 and on some
other platforms necessarily uses certain low-address memory, like the
first 640K, which must be backed up regardless.

For these reasons, it seems that it would be easiest to simply backup
the first e.g. 16 or 64 MB of memory, and not have to worry about
loading the kernel at a non-standard address and specifying a
complicated exact memmap.  Someone might prove me wrong, though.

-- 
Jeremy Maitin-Shepard
