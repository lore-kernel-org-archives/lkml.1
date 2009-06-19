Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZFSQXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZFSQXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZFSQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:23:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZFSQXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:23:36 -0400
Date: Fri, 19 Jun 2009 18:23:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: tools: Define and use our own u64, s64
	etc. definitions
Message-ID: <20090619162330.GA15197@elte.hu>
References: <19003.33494.495844.956580@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19003.33494.495844.956580@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> On 64-bit powerpc, __u64 is defined to be unsigned long rather 
> than unsigned long long.  This causes compiler warnings every time 
> we print a __u64 value with %Lx.
> 
> Rather than changing __u64, we define our own u64 to be unsigned 
> long long on all architectures, and similarly s64 as signed long 
> long. For consistency we also define u32, s32, u16, s16, u8 and 
> s8.  These definitions are put in a new header, types.h, because 
> these definitions are needed in util/string.h and util/symbol.h.
> 
> The main change here is the mechanical change of 
> __[us]{64,32,16,8} to remove the "__".  The other changes are:
> 
> * Create types.h
> * Include types.h in perf.h, util/string.h and util/symbol.h
> * Add types.h to the LIB_H definition in Makefile
> * Added (u64) casts in process_overflow_event() and print_sym_table()
>   to kill two remaining warnings.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  tools/perf/Makefile            |    1 +
>  tools/perf/builtin-annotate.c  |   66 ++++++++++++++++----------------
>  tools/perf/builtin-record.c    |   20 +++++-----
>  tools/perf/builtin-report.c    |   80 ++++++++++++++++++++--------------------
>  tools/perf/builtin-stat.c      |   62 +++++++++++++++---------------
>  tools/perf/builtin-top.c       |   24 ++++++------
>  tools/perf/perf.h              |    1 +
>  tools/perf/types.h             |   17 ++++++++
>  tools/perf/util/parse-events.c |   10 ++--
>  tools/perf/util/string.c       |    2 +-
>  tools/perf/util/string.h       |    4 +-
>  tools/perf/util/symbol.c       |   20 +++++-----
>  tools/perf/util/symbol.h       |   15 ++++---
>  13 files changed, 171 insertions(+), 151 deletions(-)
>  create mode 100644 tools/perf/types.h

Very nice, thanks a lot Paul for going through this!

	Ingo
