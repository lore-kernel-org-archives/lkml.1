Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbYBUMVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbYBUMVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYBUMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:21:41 -0500
Received: from waste.org ([66.93.16.53]:60440 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYBUMVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:21:40 -0500
Subject: Re: [PATCH 2/2] x86 : relocate uninitialized variable in init DATA
	section into init BSS section
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080221095301.GA29361@elte.hu>
References: <1203581723.4707.20.camel@caritas-dev.intel.com>
	 <20080221090557.GB20055@elte.hu>
	 <1203586106.4707.25.camel@caritas-dev.intel.com>
	 <20080221095301.GA29361@elte.hu>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 20:18:33 +0800
Message-Id: <1203596313.14838.62.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 10:53 +0100, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > > > -int __initdata early_ioremap_debug;
> > > > +int __initbss early_ioremap_debug;
> > > 
> > > will we get some sort of build error if we accidentally do:
> > > 
> > >    int __initbss early_ioremap_debug = 1;
> > > 
> > > ?
> > 
> > I tested it just now, and there is no build error.
> 
> well, that's bad. We'd silently ignore the " = 1" and boot up with that 
> value at 0, right? At minimum we need some really prominent build-time 
> _errors_ (i.e. aborted builds) if this ever happens. But ideally, 
> shouldnt this whole thing be done at link time? Couldnt the linker sort 
> the variables that are zero initialized into the right section, and move 
> this constant maintenance pressure off the programmer's shoulder?

I'm not sure if it's possible currently. But it might be possible to
instead tag objects as "init" with an attribute other than section and
then move such objects into init sections "by hand" late in the build.

-- 
Mathematics is the supreme nostalgia of our time.

