Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZEZNd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZEZNd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbZEZNdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:33:20 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:39309 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbZEZNdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:33:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAHqLG0pMQW1W/2dsb2JhbACBT80OhAsF
Date: Tue, 26 May 2009 09:33:19 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steve Langstaff <steve.langstaff@pebblebay.com>
Cc: "'David Miller'" <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       mingo@elte.hu, jwboyer@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, "'Subrata Modak'" <tosubrata@gmail.com>,
       "'Alan D. Brunelle'" <Alan.Brunelle@hp.com>,
       "'Andika Triwidada'" <andika@startrek.or.id>
Subject: Re: [ltt-dev] Test module : benchmarking read-side locking speed
Message-ID: <20090526133319.GB14851@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:31:39 up 87 days,  9:57,  4 users,  load average: 0.71, 0.43,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steve Langstaff (steve.langstaff@pebblebay.com) wrote:
> > From: Mathieu Desnoyers [mailto:compudj@krystal.dyndns.org]
> > Sent: 22 May 2009 16:02
> > To: Steve Langstaff
> > Cc: 'David Miller'; paulmck@linux.vnet.ibm.com; mingo@elte.hu;
> > jwboyer@linux.vnet.ibm.com; linux-kernel@vger.kernel.org; ltt-
> > dev@lists.casi.polymtl.ca; 'Subrata Modak'; 'Alan D. Brunelle'; 'Andika
> > Triwidada'
> > Subject: Re: [ltt-dev] Test module : benchmarking read-side locking
> > speed
> > 
> > * Steve Langstaff (steve.langstaff@pebblebay.com) wrote:
> > > > From: Mathieu Desnoyers [mailto:compudj@krystal.dyndns.org]
> > > > Sent: 21 May 2009 20:12
> > >
> > >
> > > > I am trying to complete my numbers for performance impact of read-
> > side
> > > > locking primitives (on the fast path) for various architectures.
> > >
> > > > Help with testing on a larger set of architectures would be more
> > than
> > > > welcome. Note that this module requires the kernel to be configured
> > > > with
> > > > CONFIG_PREEMPT=y. Some config option sanity checking is done at
> > > > compile-time. Other requirement : disable invasive lockdep-style
> > > > instrumentation.
> > >
> > > Another requirement is that get_cycles() needs to return something
> > > meaningful :)
> > >
> > 
> > For ARMv7 Omap3, I have the following version (I've been able to get
> > benchmarks with it yesterday). It requires LTTng to be started for the
> > trace clock infrastructure to be in place and running to provide a full
> > 64-bits emulated TSC.
> 
> Using your updated test source, I get slightly different results on my
> PXA255 (total time = 1 rather than 0), but I'm not convinced that the
> measurements are correct...
> 

The LTTng trace clock only uses the cycle counter on ARM OMAP3, AFAIK.
Therefore, the implementation you use is probably using a jiffy-based
method+logical clock (see asm-generic/trace-clock.h). Therefore those
numbers do not represent cycles.

Thanks,

Mathieu

> /lib/modules/2.6.29.2 # insmod ./ltt_test.ko
> [   81.372318] test init
> [   81.374647] Number of active CPUs : 1
> [   81.378806] test results: time for baseline
> [   81.383010] number of loops: 20000
> [   81.386510] total time: 1
> [   81.389147] -> baseline takes 0 cycles
> [   81.392910] test end
> [   81.396017] test results: time for spinlock
> [   81.400292] number of loops: 20000
> [   81.403711] total time: 1
> [   81.406417] -> spinlock takes 0 cycles
> [   81.410184] test end
> [   81.413293] test results: time for read rwlock
> [   81.417825] number of loops: 20000
> [   81.421248] total time: 1
> [   81.423887] -> read rwlock takes 0 cycles
> [   81.427990] test end
> [   81.430844] test results: time for seqlock
> [   81.434962] number of loops: 20000
> [   81.438439] total time: 1
> [   81.441075] -> seqlock takes 0 cycles
> [   81.444751] test end
> [   81.447871] test results: time for preempt disable/enable pairs
> [   81.453818] number of loops: 20000
> [   81.457300] total time: 1
> [   81.459940] -> preempt disable/enable pair takes 0 cycles
> [   81.465359] test end
> insmod: cannot insert './ltt_test.ko': Resource temporarily unavailable
> (-1): Resource temporarily unavailable
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
