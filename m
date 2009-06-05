Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZFEPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZFEPCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZFEPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:02:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZFEPCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:02:30 -0400
Date: Fri, 5 Jun 2009 12:02:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, efault@gmx.de,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip:perfcounters/core] perf report: Deal with maps
Message-ID: <20090605150205.GQ7805@ghostprotocols.net>
References: <tip-fc54db5105d01ad691a7d747064c7890e17f936c@git.kernel.org> <20090605135735.GP7805@ghostprotocols.net> <1244210784.13761.4411.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244210784.13761.4411.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 05, 2009 at 04:06:24PM +0200, Peter Zijlstra escreveu:
> On Fri, 2009-06-05 at 10:57 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jun 05, 2009 at 01:21:54PM +0000, tip-bot for Peter Zijlstra escreveu:
> > > Commit-ID:  fc54db5105d01ad691a7d747064c7890e17f936c
> > > Gitweb:     http://git.kernel.org/tip/fc54db5105d01ad691a7d747064c7890e17f936c
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Fri, 5 Jun 2009 14:04:59 +0200
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Fri, 5 Jun 2009 14:46:41 +0200
> > > 
> > > perf report: Deal with maps
> > > 
> > > In order to deal with [vdso] maps generalize the ip->symbol path
> > > a bit and allow to override some bits with custom functions.
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > LKML-Reference: <new-submission>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > 
> > > ---
> > >  Documentation/perf_counter/builtin-report.c |   37 +++++++++++++++++++++++++-
> > >  Documentation/perf_counter/util/symbol.c    |    1 +
> > >  Documentation/perf_counter/util/symbol.h    |    1 +
> > >  3 files changed, 37 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
> > > index eb5424f..9783d1e 100644
> > > --- a/Documentation/perf_counter/builtin-report.c
> > > +++ b/Documentation/perf_counter/builtin-report.c
> > > @@ -79,6 +79,7 @@ typedef union event_union {
> > >  
> > >  static LIST_HEAD(dsos);
> > >  static struct dso *kernel_dso;
> > > +static struct dso *vdso;
> > >  
> > >  static void dsos__add(struct dso *dso)
> > >  {
> > > @@ -136,6 +137,11 @@ static void dsos__fprintf(FILE *fp)
> > >  		dso__fprintf(pos, fp);
> > >  }
> > >  
> > > +static struct symbol *vdso__find_symbol(struct dso *dso, uint64_t ip)
> > > +{
> > > +	return dso__find_symbol(kernel_dso, ip);
> > > +}
> > 
> > Cut'n'paste error? s/kernel_dso/vdso/g
> 
> Ah, no, intentional cheating ;-)
> 
> the kernel dso includes the vdso symbols

OK, a comment would be nice then, will add it if you don't do it first :)

- Arnaldo
