Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZABSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZABSed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZABSeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:34:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZABSeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:34:22 -0500
Date: Fri, 2 Jan 2009 19:33:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102183353.GF10072@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102175737.GA5818@uranus.ravnborg.org> <20090102182248.GC10072@elte.hu> <20090102182915.GA6143@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102182915.GA6143@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Jan 02, 2009 at 07:22:48PM +0100, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > > And it all looks more logical too, imho.
> > > 
> > > Bugger....
> > > Now I cannot do cross compile for: alpha, arm, m68k and sparc.
> > 
> > hm, i just did a successful cross-build from x86 to alpha:
> > 
> >   KSYM    .tmp_kallsyms2.S
> >   AS      .tmp_kallsyms2.o
> >   LD      vmlinux
> >   SYSMAP  System.map
> >   SYSMAP  .tmp_System.map
> > 
> >   phoenix:~/linux/linux> head -6 /dev/shm/tip/build/.config 
> >   #
> >   # Automatically generated make config: don't edit
> >   # Linux kernel version: 2.6.28
> >   # Fri Jan  2 19:28:14 2009
> >   #
> >   CONFIG_ALPHA=y
> > 
> > with these commits present:
> > 
> >   f9d1425: Disallow gcc versions 4.1.{0,1}
> >   f153b82: Sanitize gcc version header includes
> > 
> > what type of cross-build breakage do they cause?
> 
> The default gcc made by demo-alpha with crosstool is version 4.1.0:
> 
>  /opt/crosstool/gcc-4.1.0-glibc-2.3.6/alpha-unknown-linux-gnu/bin/alpha-unknown-linux-gnu-gcc --version
> alpha-unknown-linux-gnu-gcc (GCC) 4.1.0
> Copyright (C) 2006 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

ah, ok. I build cross-compilers from scratch, so i have 4.3.3-pre:

 phoenix:~/linux/linux> /opt/crossgcc/cross/bin/alpha-linux-gcc -v
 [...]
 gcc version 4.3.3 20081123 (prerelease) (GCC) 

	Ingo
