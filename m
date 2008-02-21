Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbYBUJxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbYBUJxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765662AbYBUJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:53:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765627AbYBUJxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:53:25 -0500
Date: Thu, 21 Feb 2008 10:53:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
Message-ID: <20080221095301.GA29361@elte.hu>
References: <1203581723.4707.20.camel@caritas-dev.intel.com> <20080221090557.GB20055@elte.hu> <1203586106.4707.25.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203586106.4707.25.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Huang, Ying <ying.huang@intel.com> wrote:

> > > -int __initdata early_ioremap_debug;
> > > +int __initbss early_ioremap_debug;
> > 
> > will we get some sort of build error if we accidentally do:
> > 
> >    int __initbss early_ioremap_debug = 1;
> > 
> > ?
> 
> I tested it just now, and there is no build error.

well, that's bad. We'd silently ignore the " = 1" and boot up with that 
value at 0, right? At minimum we need some really prominent build-time 
_errors_ (i.e. aborted builds) if this ever happens. But ideally, 
shouldnt this whole thing be done at link time? Couldnt the linker sort 
the variables that are zero initialized into the right section, and move 
this constant maintenance pressure off the programmer's shoulder?

	Ingo
