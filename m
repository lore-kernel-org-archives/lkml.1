Return-Path: <linux-kernel-owner+w=401wt.eu-S2992702AbXCGWr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702AbXCGWr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXCGWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:47:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40392 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992702AbXCGWrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:47:55 -0500
Date: Wed, 7 Mar 2007 23:47:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       rjw@sisk.pl
Subject: Re: [PATCH 15/20] Move swsusp __pa() dependent code to arch portion
Message-ID: <20070307224740.GF5956@elf.ucw.cz>
References: <20070307065703.GA23412@in.ibm.com> <20070307071850.GP23412@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307071850.GP23412@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> o __pa() should be used only on kernel linearly mapped virtual addresses
>   and not on kernel text and data addresses.
> 
> o Hibernation code needs to determine the physical address associated
>   with kernel symbol to mark a section boundary which contains pages which
>   don't have to be saved and restored during hibernate/resume operation.
> 
> o Move this piece of code in arch dependent section. So that architectures
>   which don't have kernel text/data mapped into kernel linearly mapped
>   region can come up with their own ways of determining physical addresses
>   associated with a kernel text.
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>

...hmm, but that means 3 copies of same code. Can we put the

> +/*
> + *	pfn_is_nosave - check if given pfn is in the 'nosave' section
> + */
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +	unsigned long nosave_begin_pfn = __pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
> +	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> +	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> +}

...in asm-generic/suspend.h (or something) and then just include it?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
