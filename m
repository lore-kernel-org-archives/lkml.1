Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZGALyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZGALyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZGALyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:54:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZGALyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:54:32 -0400
Date: Wed, 1 Jul 2009 13:54:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Message-ID: <20090701115425.GJ15958@elte.hu>
References: <20090630215437.GB22851@elte.hu> <20090630212454.19294.75622.stgit@warthog.procyon.org.uk> <20090630213406.GB17492@elte.hu> <200906302341.58582.arnd@arndb.de> <22582.1246447691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22582.1246447691@redhat.com>
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
> > It would make sense to wire it up for real as it's really easy: 
> > just set HAVE_PERF_COUNTERS in arch/frv/Kconfig, add an empty 
> > arch/frv/include/asm/perf_counter.h file. (Optional: double 
> > check that tools/perf/ builds and works fine on FRV ;-)
> 
> Are these for hardware performance counters?

No. PMU support is not necessary in the first step, you'll still get 
plenty of features from enabling perfcounters on FRV:

  - hrtimer driven recording/profiling

  - various software counters

  - working perf top / perf stat / perf record / perf report

The tools will all work out of box and there's a transparent 
fall-back path in the tools if the hardware counters are not 
available.

It's much easier to add than basic Oprofile support, and you'll get 
a lot more features in exchange as well ;)

[ There might be unanticipated problems of course - please report to
  us any problems (tools/perf/ does not build cleanly, features dont
  work as expected, etc.). ]

	Ingo
