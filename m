Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbXJKAIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbXJKAIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXJKAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:08:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:56444 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXJKAIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nbl3gjllgE8WY6663zTePVeYriwi+KsImoe0JEj+xiWIy9tvy6Px1TLDrUk1YrdMocBU5/OfMors4WstELHNpzmLDEYlGxCtMWgrVKk2Fmqtat8q6N/MUKn9Vv+CEg+5BE8ejNteZR0a61qIrjNHlos0mthUr+59qzzJLK4s0OQ=
Message-ID: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
Date: Wed, 10 Oct 2007 17:08:05 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [OT] Argument with an OS professor over profile=3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been having a back and forth going for a while with my TA and OS
professor on the meaning of profile=3 and have been unable to convince
either of them. The basic question is if profile=3 is passed to kernel
with an 8MB text section, how big is the allocated profile buffer. His
answer is 1MB....

        if (prof_shift) {
                unsigned int size;
                /* only text is profiled */
                prof_len = (unsigned *) &_etext - (unsigned *) &_stext;
                prof_len >>= prof_shift;

                size = prof_len * sizeof(unsigned int) + PAGE_SIZE-1;
                prof_buffer = (unsigned int *) alloc_bootmem(size);
        }

I've booted linux with profile=3 and pointed to the dmesg output. I've
copied the code out of init/main.c into a test program and run it.
I've even pointed to the comment in the Makefile for linux-0.98. He
seems to think that there is pointer arithmetic taking place. To make
matters worse, our textbook "Linux Core Kernel Commentary, 2nd
Edition", also has an incorrect answer. It states "A prof_shift value
of 2, for example, allocates an amount of memory equal to 25 percent
of the kernel's code size to profile the kernel." And of  course, he's
been giving the exam for 4 years and no one else complained.

Anyway, a reply from whoever sent this message back in 1992:

http://groups.google.com/group/comp.os.linux/browse_thread/thread/d84462f394d3a206/dfee60779481ccec?lnk=st&q=&rnum=4#dfee60779481ccec

> I wrote a kernel profiling utility for this, and sent the patches
> (small) and a user-level program to print out results (even smaller) to
> the kernel mailing-list.  If anybody sees this slow-down problem, and
> tries out the profiling code, I'd be interested to have some sample
> output.
>
> If you aren't on the kernel list, I can make the patches available on
> the net.

would be nice. I heard he had arguments with his OS prof's back in the
day. (even neater if someone had the email that was sent to whatever
that kernel list was, just for my general curiosity), but emails from
others would be nice too :)




A few secondary questions that aren't nearly as important. Is IRQ used
an abbreviation for interrupt, or does it have a separate meaning to
kernel developers?

Rate the following responses on a scale from 1-10:

Why does the source code use 14 calls to BUILD_16_IRQS each of which
makes 16 calls to BI (which expands to BUILD_IRQ) instead of 224 calls
to BUILD_IRQ?

Reduce amount of source code and redundancy

224 calls would be ugly and difficult to maintain. Plus, kernel
developers are lazv, they don't want to have to copy&paste 224 times.

Thanks, I work full time and attend graduate school full time, I've
already spent far too much time arguing with my prof and TA.
