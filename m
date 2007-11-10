Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXKJUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXKJUcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXKJUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:32:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbXKJUck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:32:40 -0500
To: gregkh@suse.de
Cc: akpm@osdl.org, eranian@hpl.hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
From: Andi Kleen <andi@firstfloor.org>
References: <20071107003454.GA13374@kroah.com>
	<20071109120627.60ec9ab4.akpm@linux-foundation.org>
	<20071109213829.GC28276@kroah.com>
Date: Sat, 10 Nov 2007 21:32:39 +0100
In-Reply-To: <20071109213829.GC28276@kroah.com> (Greg KH's message of "Fri\, 9 Nov 2007 13\:38\:29 -0800")
Message-ID: <p73abpl2654.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> writes:

[dropped perfmon list because gmane messed it up and it's apparently
closed anyways]

> Is there any way to just provide a basic framework that everyone can
> agree on and then add on more stuff as time goes on?  Do we have to have
> every different processor/arch with support to start with?

I think the real problem are not the architectures (the processor
adaption layer is usually relatively straight forward IIRC), but the
excessive functionality implemented by the user interface.

It would be really good to extract a core perfmon and start with
that and then add stuff as it makes sense.

e.g. core perfmon could be something simple like just support
to context switch state and initialize counters in a basic way 
and perhaps get counter numbers for RDPMC in ring3 on x86[1]

Next step could be basic event on overflow/underflow support.

Then more features as they make sense, with clear rationale
what they're good for and proper step by step patches. 

-Andi

[1] On x86 we urgently need a replacement to RDTSC for counting
cycles.
