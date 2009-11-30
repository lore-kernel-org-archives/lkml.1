Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZK3IUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZK3IUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZK3IUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:20:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZK3IUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:20:15 -0500
Date: Mon, 30 Nov 2009 09:19:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       anton@samba.org, hch@infradead.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/4] Fixes for perf/scripting
Message-ID: <20091130081951.GA20717@elte.hu>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Tom Zanussi (4):
>   perf trace/scripting: silence PERL_EMBED_* backtick errors
>   perf trace/scripting: ignore shadowed variable warning for
>     perf-trace-perl.c
>   perf trace/scripting: fix Perl common_* access functions
>   perf trace/scripting: Add Fedora libperl install note to doc
> 
>  tools/perf/Makefile                                |    6 ++--
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   30 ++++++++++----------
>  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    6 ++--
>  tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
>  tools/perf/util/trace-event-perl.c                 |   10 ++++--
>  tools/perf/util/trace-event-perl.h                 |    6 ++--
>  6 files changed, 32 insertions(+), 30 deletions(-)

Applied, thanks Tom!

I tried a few simple things and it worked fine, so i put it into the 
permanent perf/scripting branch. I think this looks like a nice feature: 
a perfect fit to do rapid prototyping of tracing applets. (or just to 
use it for ad-hoc, programming based analysis of tracing data)

There's a few odd ends to 'perf trace' usability we need to fix before 
this can be merged into perf/core. For example if libperl isnt 
installed, 'perf trace' emits this warning:

 Perl scripting not supported.  Install libperl and rebuild perf to 
 enable it.  e.g. apt-get install libperl-dev (ubuntu), yum install 
 perl-ExtUtils-Embed (Fedora), etc.

We should only emit that if -g or -s is used - it's a nuisance in the 
other cases. Most distributions dont have libperl installed by default.

Also, a few simple examples and some heads-up about the power of 
scripting should be put into Documentation/perf-trace.txt as well. 
Something minimal - and it can include a Perl example as well. Some 
practical version of perl/Perf-Trace-Util/README or so. We want curious 
people who know Perl and try 'perf trace --help' to have some minimal 
entry vector into this space.

A third question is - right now we install the sample Perl scripts on 
'make install', but there's no mechanism to see the scripts that are 
available. 'perf trace -l/--list' might be useful?

I.e. the whole pathway of random perf users coming in and starting to 
use the script engine 'spontaneusly' and 'intuitively' is not yet 
thought through - the capabilities are hidden too much.

Thanks,

	Ingo
