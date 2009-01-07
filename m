Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbZAGWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbZAGWKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAGWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:10:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33814 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZAGWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:10:38 -0500
Date: Wed, 7 Jan 2009 23:10:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/15] ACPICA: move common private headers under
	kernel/acpi/acpica/
Message-ID: <20090107221017.GD17917@elte.hu>
References: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <c6b6f68232ab6da57e764c64b23b4649c4e7c463.1230719801.git.len.brown@intel.com> <20090102191451.GB14249@elte.hu> <alpine.LFD.2.00.0901021438060.3590@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021438060.3590@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> > If it goes there then IMHO the ACPI code needs to be cleaned up 
> > _significantly_ to not wrap native Linux calls like spinlocks, 
> > allocators, etc.
> 
> Are there different style guidelines for the src/kernel/
> directory versus other parts of the source tree?
> 
> The acpi/acpica/ sub-directory is a processed version of code that we 
> share with BSD, opensolaris, and every ACPI-capable OS on Earth besides 
> Microsoft's.  There is a huge commmon benefit to that sharing, and the 
> Linux community's tolerance of wrappers, shims, and other unconventional 
> things allows that sharing to work without an infinite amount of 
> additional make-work.

i still tend to regard kernel/* as the core Linux kernel, as code that can 
be improved infinitely (only subject to the laws of physics), without 
having to worry about how the ACPI spec wants certain things done.

The moment you bring in "this has to work on BSD, etc." arguments it will 
be a never ending excuse for crap. Standards tend to create the _worst_ 
possible code, because every vendor compromizes a bit on another vendor's 
crap, just to be able to get in their own important crap. So the more 
vendors there are in a standards group, the crappier the end result is 
technically.

Also, ACPI is an environment/bootstrap detail well placed under 
drivers/acpi/ - why should it move to kernel/acpi/ ? The fact that it's 
used widely is immaterial - by that argument we could move arch/x86/ to 
kernel/x86/, and we could move drivers/ata/ to kernel/ata/ as well. (they 
are probably even more widely deployed than ACPI)

	Ingo
