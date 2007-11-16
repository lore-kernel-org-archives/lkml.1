Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXKPTPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXKPTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXKPTO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:14:57 -0500
Received: from gw.goop.org ([64.81.55.164]:43070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbXKPTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:14:56 -0500
Message-ID: <473DEC1C.8080506@goop.org>
Date: Fri, 16 Nov 2007 11:14:36 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org> <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711160921510.4260@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So don't do it. Just preallocate for the magic 4-entry PGD. You can make 
> the special case just be something like
>   

Yes, OK, it makes sense.  Conceptually they would be dynamically
allocated and freed, but they'd just happen to start allocated, to avoid
the tlb flush of populating the pgd of an active pagetable.  If you
happened to do a 1G munmap, it may end up freeing and reallocating them,
but that's going to be very rare.  Either way, the other special cases
are avoided (though pgd_populate would still need to be correct, on the
offchance it gets invoked).

    J
