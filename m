Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZGAOKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZGAOKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZGAOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:10:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46476 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZGAOKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:10:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090701131326.GB13524@elte.hu>
References: <20090701131326.GB13524@elte.hu> <19019.22629.720187.794661@cargo.ozlabs.ibm.com> <20090701115425.GJ15958@elte.hu> <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com> <32551.1246450797@redhat.com> <32707.1246452087@redhat.com> 
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Paul Mackerras <paulus@samba.org>,
       Arnd Bergmann <arnd@arndb.de>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Date: Wed, 01 Jul 2009 15:10:03 +0100
Message-ID: <30887.1246457403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Yeah - still i'd suggest to just go with the generic code initially, 

Nah, that's no fun!  Besides, the code is very similar to the 32-bit code, and
I'm fairly certain it'll work.  I can also check it very easily by dumping
some temp test code in setup.c.

Anyway, I see the following errors:

kernel/perf_counter.c: In function 'perf_counter_index':
kernel/perf_counter.c:1889: error: 'PERF_COUNTER_INDEX_OFFSET' undeclared (first use in this function)
kernel/perf_counter.c:1889: error: (Each undeclared identifier is reported only once
kernel/perf_counter.c:1889: error: for each function it appears in.)
  CC      block/as-iosched.o
kernel/perf_counter.c:1890: warning: control reaches end of non-void function

But this symbol appears to be undocumented:

	warthog>grep -r PERF_COUNTER_INDEX_OFFSET Documentation/
	warthog1>grep -r INDEX_OFFSET Documentation/
	warthog1>

David
