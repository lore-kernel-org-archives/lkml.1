Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZGAOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZGAOt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZGAOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:49:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZGAOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:49:21 -0400
Date: Wed, 1 Jul 2009 16:49:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Message-ID: <20090701144913.GA28172@elte.hu>
References: <19019.22629.720187.794661@cargo.ozlabs.ibm.com> <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com> <32551.1246450797@redhat.com> <32707.1246452087@redhat.com> <30887.1246457403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30887.1246457403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Yeah - still i'd suggest to just go with the generic code initially, 
> 
> Nah, that's no fun!  Besides, the code is very similar to the 32-bit code, and
> I'm fairly certain it'll work.  I can also check it very easily by dumping
> some temp test code in setup.c.
> 
> Anyway, I see the following errors:
> 
> kernel/perf_counter.c: In function 'perf_counter_index':
> kernel/perf_counter.c:1889: error: 'PERF_COUNTER_INDEX_OFFSET' undeclared (first use in this function)
> kernel/perf_counter.c:1889: error: (Each undeclared identifier is reported only once
> kernel/perf_counter.c:1889: error: for each function it appears in.)
>   CC      block/as-iosched.o
> kernel/perf_counter.c:1890: warning: control reaches end of non-void function

Ok, indeed - you can define it to 0 for now - FRV wont set hw 
counters so it doesnt matter. It is used for the hw index in the 
mmap head for 'direct' access to the PMU, using special instructions 
like RDPMC (on x86). Probably not relevant to FRV.

> But this symbol appears to be undocumented:
> 
> 	warthog>grep -r PERF_COUNTER_INDEX_OFFSET Documentation/
> 	warthog1>grep -r INDEX_OFFSET Documentation/
> 	warthog1>

You can use the power of the Git space:

   git log -SPERF_COUNTER_INDEX_OFFSET

:-)

	Ingo
