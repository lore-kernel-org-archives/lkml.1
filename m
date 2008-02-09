Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYBIIYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYBIIYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYBIIYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:24:35 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:38570 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYBIIYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:24:34 -0500
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some
	processors
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
In-Reply-To: <1202512812.17934.680.camel@cinder.waste.org>
References: <200802082347.25364.michael-lists@free-electrons.com>
	 <1202512812.17934.680.camel@cinder.waste.org>
Content-Type: text/plain; charset=utf-8
Date: Sat, 09 Feb 2008 09:30:17 +0100
Message-Id: <1202545817.6722.24.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fre, 08 02 2008 kl. 17:20 -0600, skrev Matt Mackall:
> On Fri, 2008-02-08 at 23:47 +0100, Michael Opdenacker wrote:
> > This patch against x86/mm tries to revive an original patch
> > from Matt Mackall which didn't get merged at that time. It makes
> > it possible to disable support code for some processors. This can
> > be useful to support only the exact processor type used
> > in a given system.
> > 
> > I may have made wrong assumptions with the code handling
> > force_mwait. As force_mwait is only declared in
> > arch/x86/kernel/cpu/amd.c, which is only compiled
> > when CONFIG_X86_32 is set, I thought it was safe
> > to make the code depend on CONFIG_CPU_SUP_AMD,
> > but I could be wrong.
> > 
> > Your comments are more than welcome! To make the code
> > cleaner, I could use empty inline functions instead
> > of ifdef's, as suggested in Documentation/SubmittingPatches.
> 
> Please include the output of size with all these options on and off.

The build of my currently running kernel for my laptop has
$ size -t amd.o cyrix.o centaur.o transmeta.o intel.o nexgen.o umc.o
   text	   data	    bss	    dec	    hex	filename
   2809	    316	      0	   3125	    c35	amd.o
   2387	    856	      0	   3243	    cab	cyrix.o
   1514	    312	      0	   1826	    722	centaur.o
   1279	    312	      0	   1591	    637	transmeta.o
   1783	    316	      0	   2099	    833	intel.o
    126	    312	      0	    438	    1b6	nexgen.o
     41	    312	      0	    353	    161	umc.o
   9939	   2736	      0	  12675	   3183	(TOTALS)

That is without optimize for size compilation, with that set I get
$ size -t amd.o cyrix.o centaur.o transmeta.o intel.o nexgen.o umc.o
   text	   data	    bss	    dec	    hex	filename
   2300	    316	      0	   2616	    a38	amd.o
   2132	    820	      0	   2952	    b88	cyrix.o
   1325	    312	      0	   1637	    665	centaur.o
   1151	    312	      0	   1463	    5b7	transmeta.o
   1575	    316	      0	   1891	    763	intel.o
    107	    312	      0	    419	    1a3	nexgen.o
     41	    312	      0	    353	    161	umc.o
   8631	   2700	      0	  11331	   2c43	(TOTALS)

I don't think the code changes in the patch do much with respect to
size.


Simon Holm Thøgersen

