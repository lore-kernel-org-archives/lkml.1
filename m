Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZLOCch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZLOCch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZLOCcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:32:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49406 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZLOCce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:32:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P7jAAzKQk8DBt9bzW9aPXyIA1kJaBqGQMN0Lk1h1MbTEqU5qF6PuCc9nN7z4Xlz5JN
         YNnEkm3ipLO+8PqiZ1Vg/lDMNzvkFlbFkqwNkaCunox0q6yOqJbZ1GSmlIVlgN+cXUO7
         gOlkm49DQCERgutbw5mf23bTka0r+H/3DPhhg=
Date: Tue, 15 Dec 2009 03:32:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Allow lookups by symbol name
	too
Message-ID: <20091215023228.GC6048@nowhere>
References: <1260564622-12392-1-git-send-email-acme@infradead.org> <tip-79406cd789f745ac6aa9d597895f904a98a14007@git.kernel.org> <20091215021201.GB6048@nowhere> <20091215022020.GD21796@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215022020.GD21796@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:20:20AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 15, 2009 at 03:12:03AM +0100, Frederic Weisbecker escreveu:
> > On Sat, Dec 12, 2009 at 07:22:03AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> > > Looking over the vmlinux/kallsyms is common enough that I'll add a
> > > variable to the upcoming struct perf_session to avoid the need to
> > > use map_groups__find_by_name to get the main vmlinux/kallsyms map.
> > > 
> > > The above example looks on the 'variable' symtab, but it is just
> > > like that for the functions one.
> > > 
> > > Also the sort operation is done when we first use
> > > map__find_symbol_by_name, in a lazy way.
> > 
> > It would be nice to also have a kernel symbol resolution
> > helper independant of any session.
> > 
> > The problem is that I need to resolve a kernel variable symbol
> > very early, when we parse record options. We don't have any
> > session at this time so I can't retrieve the kmaps.
> 
> Humm, I don't think that is a problem, we just have to create the
> session before processing the args, after all at record time we can use
> kallsyms already.



Yeah but we need the output filename before creating it, which
we even don't have yet at this time.

May be I should just init it very early without the filename
and assign it later with a small new helper.

Another problem is that the record session is not available
from parse-events.c, may be should I create a single wide scope
record_session that would be shared among record, top and stat
so that it's available from parse-event.c


> 
> > I'm not sure what's the proper way to handle that.
> 
> What is the problem? I'm not following :-)


I think the real problem actually is that I should join
my bed.
The above questions will retrieve their trivial essence after
some sleep :)

