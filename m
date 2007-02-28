Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXB1GmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXB1GmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 01:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXB1GmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 01:42:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43030 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXB1GmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 01:42:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
	<20070221114737.a09be761.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
Date: Tue, 27 Feb 2007 23:37:14 -0700
In-Reply-To: <Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 21 Feb 2007 12:09:38 -0800 (PST)")
Message-ID: <m1lkiikcth.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm..  I seem to have failed to send out this reply a few days ago :(

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 21 Feb 2007, Andrew Morton wrote:
>> > 
>> >
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
>> >
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
>> 
>> That's mainly an Andi decision.  Let's cc him.
>
> Would be good to have Eric also ack them as safe and obvious.
>
> Btw, that latter one has corrupted sign-offs from Andi (it's in the middle 
> of the text, very confusing).

There are two questions.
1) What can we do to make the situation better.
2) Is the hole completely plugged.

When I wrote the patch I had the local apic priorities backwards in my
head.  So apic_in_service_vector can return the wrong value if two
irqs are in service.  Now I don't think we allows ourselves to enable
interrupts in an interrupt service routing until after we have acked
the local apic so this should be harmless.  The fix is also trivial
of just having apic_in_service_vector return: "~get_irq_regs()->orig_rax".

Except for that one possible problem everything I can think of are
just theoretical cracks at this point, and they don't make the
situation any worse.

Given that this patch has appears to have undergone a noticeable
amount of testing, by people other than myself, and clears up the
symptoms.  I have no problem 


Eric
