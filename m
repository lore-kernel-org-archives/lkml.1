Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZFPKhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZFPKhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZFPKhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:37:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFPKhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:37:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
In-Reply-To: Petr Tesarik's message of  Tuesday, 16 June 2009 11:55:01 +0200 <1245146101.17481.202.camel@nathan.suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	<20090616084015.5D2E44B6FD@magilla.sf.frob.com>
	<1245146101.17481.202.camel@nathan.suse.cz>
X-Zippy-Says: ..  Now I think I just reached the state of HYPERTENSION that comes
    JUST BEFORE you see the TOTAL at the SAFEWAY CHECKOUT COUNTER!
Message-Id: <20090616103445.A3008D56E@magilla.sf.frob.com>
Date: Tue, 16 Jun 2009 03:34:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Upfront, thank you very much for reviewing the series, Roland!

I'm glad to help.

> And there currently isn't one. But the writability of the vDSO is a bit
> more complicated. True, the VMA is initially mapped read-only, but it is
> possible to make it writable using mprotect(). 

Except for CONFIG_COMPAT_VDSO on X86_32.

> You may also set an
> INT3-style breakpoint in the vDSO area. So, it's all about policy. If
> there were any demand to make the vDSO writable, it could be done with a
> trivial patch.

There's a big difference between "writable" and "might be written".

> If we do not _WANT_ to make it writable, then we can simply add .data
> and .bss to .broken.

That is the correct thing to do.

> Yes, all .rel* sections should be in .broken, I guess.

You can toss an "void *x = &x;" into the vdso sources to verify that this
setup makes that explode gracefully.

> This was an attempt to discard .note.GNU-stack, which is what the
> default linker script does, but it appears that all .note.GNU-stack
> sections are zero-size, so this change does not make any difference.

Indeed it does not.


Thanks,
Roland
