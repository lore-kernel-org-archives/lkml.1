Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbZLAFah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbZLAFah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 00:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZLAFag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 00:30:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62538 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZLAFaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 00:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WxeeqsKzic/LoNeUtJWbvx2dLI5FHK/lAR7SrFn5WiFnXQwtw/DAzedFze4+cXkCDw
         R7gSbI/gUKV6DNEiPVqlfP8uqUfXIiU8ZVwGlWi8p4tdl3JMaz+Zm+9ZBadivcGhirry
         ClUoep+2UQOZ2QTIKdVJFbLauCg2jjrVX+ppg=
Subject: Re: [PATCH 0/4] Fixes for perf/scripting
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       anton@samba.org, hch@infradead.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20091130081951.GA20717@elte.hu>
References: <1259565529-6407-1-git-send-email-tzanussi@gmail.com>
	 <20091130081951.GA20717@elte.hu>
Content-Type: text/plain
Date: Mon, 30 Nov 2009 23:30:38 -0600
Message-Id: <1259645438.6053.7.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 09:19 +0100, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Tom Zanussi (4):
> >   perf trace/scripting: silence PERL_EMBED_* backtick errors
> >   perf trace/scripting: ignore shadowed variable warning for
> >     perf-trace-perl.c
> >   perf trace/scripting: fix Perl common_* access functions
> >   perf trace/scripting: Add Fedora libperl install note to doc
> > 
> >  tools/perf/Makefile                                |    6 ++--
> >  tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |   30 ++++++++++----------
> >  tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    6 ++--
> >  tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
> >  tools/perf/util/trace-event-perl.c                 |   10 ++++--
> >  tools/perf/util/trace-event-perl.h                 |    6 ++--
> >  6 files changed, 32 insertions(+), 30 deletions(-)
> 
> Applied, thanks Tom!
> 
> I tried a few simple things and it worked fine, so i put it into the 
> permanent perf/scripting branch. I think this looks like a nice feature: 
> a perfect fit to do rapid prototyping of tracing applets. (or just to 
> use it for ad-hoc, programming based analysis of tracing data)
> 

Great, thanks!

I agree that usability is key and could use some more work - I'll submit
some more patches addressing that soon...

Thanks,

Tom

> There's a few odd ends to 'perf trace' usability we need to fix before 
> this can be merged into perf/core. For example if libperl isnt 
> installed, 'perf trace' emits this warning:
> 
>  Perl scripting not supported.  Install libperl and rebuild perf to 
>  enable it.  e.g. apt-get install libperl-dev (ubuntu), yum install 
>  perl-ExtUtils-Embed (Fedora), etc.
> 
> We should only emit that if -g or -s is used - it's a nuisance in the 
> other cases. Most distributions dont have libperl installed by default.
> 
> Also, a few simple examples and some heads-up about the power of 
> scripting should be put into Documentation/perf-trace.txt as well. 
> Something minimal - and it can include a Perl example as well. Some 
> practical version of perl/Perf-Trace-Util/README or so. We want curious 
> people who know Perl and try 'perf trace --help' to have some minimal 
> entry vector into this space.
> 
> A third question is - right now we install the sample Perl scripts on 
> 'make install', but there's no mechanism to see the scripts that are 
> available. 'perf trace -l/--list' might be useful?
> 
> I.e. the whole pathway of random perf users coming in and starting to 
> use the script engine 'spontaneusly' and 'intuitively' is not yet 
> thought through - the capabilities are hidden too much.
> 
> Thanks,
> 
> 	Ingo

