Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZLOCoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZLOCoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZLOCoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:44:14 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63886 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbZLOCoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=CKMUjcmMIlCQ18kikx/L1iI3rI/GVSKmggsYSojWf4JUYfvA0+eaXEW9rX53/UtFXr
         /G+V1df2T2W/DiD6BLjLKTCBkXnQwX/cS/CceyqackiDFvomW+peRs+JNx3cvFjR9bts
         omJU0Wogd6lFt75eYHX22TGlLXFJA5kcw4aiE=
Date: Tue, 15 Dec 2009 00:44:06 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Allow lookups by symbol name too
Message-ID: <20091215024406.GA27237@ghostprotocols.net>
References: <1260564622-12392-1-git-send-email-acme@infradead.org>
 <tip-79406cd789f745ac6aa9d597895f904a98a14007@git.kernel.org>
 <20091215021201.GB6048@nowhere>
 <20091215022020.GD21796@ghostprotocols.net>
 <20091215023228.GC6048@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215023228.GC6048@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 15, 2009 at 03:32:30AM +0100, Frederic Weisbecker escreveu:
> On Tue, Dec 15, 2009 at 12:20:20AM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 15, 2009 at 03:12:03AM +0100, Frederic Weisbecker escreveu:
> > > On Sat, Dec 12, 2009 at 07:22:03AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> > > > Looking over the vmlinux/kallsyms is common enough that I'll add a
> > > > variable to the upcoming struct perf_session to avoid the need to
> > > > use map_groups__find_by_name to get the main vmlinux/kallsyms map.
> > > > 
> > > > The above example looks on the 'variable' symtab, but it is just
> > > > like that for the functions one.
> > > > 
> > > > Also the sort operation is done when we first use
> > > > map__find_symbol_by_name, in a lazy way.
> > > 
> > > It would be nice to also have a kernel symbol resolution
> > > helper independant of any session.
> > > 
> > > The problem is that I need to resolve a kernel variable symbol
> > > very early, when we parse record options. We don't have any
> > > session at this time so I can't retrieve the kmaps.
> > 
> > Humm, I don't think that is a problem, we just have to create the
> > session before processing the args, after all at record time we can use
> > kallsyms already.
> 
> Yeah but we need the output filename before creating it, which
> we even don't have yet at this time.

Well, see top it should shed some light:

        /*
         * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
         * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
         */
        struct perf_session *session = perf_session__new(NULL, O_WRONLY, false,
                                                         &symbol_conf);

8-)

> May be I should just init it very early without the filename
> and assign it later with a small new helper.
> 
> Another problem is that the record session is not available
> from parse-events.c, may be should I create a single wide scope
> record_session that would be shared among record, top and stat
> so that it's available from parse-event.c
> 
> > > I'm not sure what's the proper way to handle that.
> > 
> > What is the problem? I'm not following :-)
> 
> I think the real problem actually is that I should join
> my bed.
> The above questions will retrieve their trivial essence after
> some sleep :)

Ok, I'm some hours behind you but neverthless ahead of my own bedtime,
lets see tomorrow how to add support for your scenario and for O_MMAP
before some other top-like app needs to use our mutant teenage libperf
kid :-)

- Arnaldo
