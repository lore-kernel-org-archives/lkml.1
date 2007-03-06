Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXCFN1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXCFN1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030611AbXCFN1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:27:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030632AbXCFN1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:27:01 -0500
Date: Tue, 6 Mar 2007 14:26:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/8] Remove cpu_gdt_table: use boot_gdt_table until migration to per-cpu
Message-ID: <20070306132613.GA12964@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <20070306132004.GD9031@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306132004.GD9031@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > +	.quad 0x00cf9a000000ffff	/* boot: 4GB code at 0x00000000 */
> > +	.quad 0x00cf92000000ffff	/* boot: 4GB data at 0x00000000 */
> >  	.quad 0x0000000000000000	/* 0x20 unused */
> >  	.quad 0x0000000000000000	/* 0x28 unused */
> >  	.quad 0x0000000000000000	/* 0x33 TLS entry 1 */
> 
> actually, the reason for the small boot GDT was that some systems 
> wouldnt even boot with a larger GDT. (there was some BIOS interaction, 
> forgot what it was - iirc it was mach-visws and also some other older 
> box)
> 
> the 'simplification' you do here is actually how Linux worked before 
> it was fixed for those systems.
> 
> so i'd be quite nervous to touch this area of the GDT code. (I'd 
> support a renaming though, gdt_table is indeed ugly.)

and this seems to have a ripple effect on the rest of your GDT changes - 
i'll wait for this to be cleared before doing a line by line review of 
them. I commented on the mostly-unaffected ones already.

	Ingo
