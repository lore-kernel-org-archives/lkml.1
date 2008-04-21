Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDUV5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDUV5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYDUV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:57:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58149 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbYDUV5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:57:16 -0400
Subject: Re: Voyager phys_cpu_present_map compile error
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080421201434.GN8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	 <20080421085314.GI26897@cs181133002.pp.htv.fi>
	 <20080421120054.GA6788@elte.hu>
	 <20080421132705.GG6011@cs181133002.pp.htv.fi>
	 <20080421201434.GN8770@elte.hu>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 16:57:11 -0500
Message-Id: <1208815032.3640.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-21 at 22:14 +0200, Ingo Molnar wrote:
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > +#ifndef CONFIG_X86_VOYAGER
> > >  /* Bitmask of physically existing CPUs */
> > >  physid_mask_t phys_cpu_present_map;
> > > +#endif
> > >...
> > 
> > Alexey noted that phys_cpu_present_map for Voyager and !Voyager also 
> > have different types and suggested to make the Voyager one static 
> > instead (additional renaming of the Voyager one also makes sense).
> 
> yep, done by the patch below.

Hang on; this doesn't looks like such a good idea.  Why don't the
definitions match?  CPU type maps are supposed to be of type cpumask_t,
so why bother reinventing a physid_mask_t which is essentially a cut and
paste cpumask_t but on MAX_APICS instead of NR_CPUS ... surely we don't
have to have that duplication ... particularly as m32r has gone and
copied your definitions.

I'm guessing you want large sparse phys maps and smaller logical cpumaps
(although I'm not clear which archs can have a greater physical id than
they support as cpus)?  In which case, it still makes sense for this to
be generic, using similar code in  linux/cpumask.h to avoid further
duplication?

James


