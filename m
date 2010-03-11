Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab0CKPYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:24:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab0CKPYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:24:47 -0500
Date: Thu, 11 Mar 2010 16:24:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Kyle McMartin <kyle@redhat.com>
Subject: Re: [PATCH] perf: Make the install relative to DESTDIR if specified
Message-ID: <20100311152421.GA5577@elte.hu>
References: <20100311141438.GA31225@elte.hu>
 <313773182.3316301268318778469.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <313773182.3316301268318778469.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
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


* John Kacur <jkacur@redhat.com> wrote:

> 
> ----- "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> > * John Kacur <jkacur@redhat.com> wrote:
> > 
> > > On Thu, Mar 11, 2010 at 1:57 PM, John Kacur <jkacur@redhat.com>
> > wrote:
> > > > Without this change, the install path is relative to
> > > > prefix/DESTDIR
> > > > where prefix is automatically set to $HOME
> > > >
> > > > This can produce unexpected results. For example
> > > >
> > > > make -C tools/perf DESTDIR=/home/jkacur/tmp install-man
> > > >
> > > > creates the directory: ? ? ? ?
> > ?/home/jkacur/home/jkacur/tmp/share/...
> > > > instead of ?the expected: ? ? ? /home/jkacur/tmp/share/...
> > > >
> > > > Signed-off-by: John Kacur <jkacur@redhat.com>
> > > > ---
> > > > ?tools/perf/Documentation/Makefile | ? ?4 +++-
> > > > ?tools/perf/Makefile ? ? ? ? ? ? ? | ? ?4 +++-
> > > > ?2 files changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/tools/perf/Documentation/Makefile
> > b/tools/perf/Documentation/Makefile
> > > > index bdd3b7e..bd498d4 100644
> > > > --- a/tools/perf/Documentation/Makefile
> > > > +++ b/tools/perf/Documentation/Makefile
> > > > @@ -24,7 +24,10 @@ DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
> > > > ?DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
> > > > ?DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
> > > >
> > > > +# Make the path relative to DESTDIR, not prefix
> > > > +ifndef DESTDIR
> > > > ?prefix?=$(HOME)
> > > > +endif
> > > > ?bindir?=$(prefix)/bin
> > > > ?htmldir?=$(prefix)/share/doc/perf-doc
> > > > ?pdfdir?=$(prefix)/share/doc/perf-doc
> > > > @@ -32,7 +35,6 @@ mandir?=$(prefix)/share/man
> > > > ?man1dir=$(mandir)/man1
> > > > ?man5dir=$(mandir)/man5
> > > > ?man7dir=$(mandir)/man7
> > > > -# DESTDIR=
> > > >
> > > > ?ASCIIDOC=asciidoc
> > > > ?ASCIIDOC_EXTRA = --unsafe
> > > > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > > > index 2d53738..5da0cd0 100644
> > > > --- a/tools/perf/Makefile
> > > > +++ b/tools/perf/Makefile
> > > > @@ -216,7 +216,10 @@ STRIP ?= strip
> > > > ?# runtime figures out where they are based on the path to the
> > executable.
> > > > ?# This can help installing the suite in a relocatable way.
> > > >
> > > > +# Make the path relative to DESTDIR, not to prefix
> > > > +ifndef DESTDIR
> > > > ?prefix = $(HOME)
> > > > +endif
> > > > ?bindir_relative = bin
> > > > ?bindir = $(prefix)/$(bindir_relative)
> > > > ?mandir = share/man
> > > > @@ -233,7 +236,6 @@ sysconfdir = $(prefix)/etc
> > > > ?ETC_PERFCONFIG = etc/perfconfig
> > > > ?endif
> > > > ?lib = lib
> > > > -# DESTDIR=
> > > >
> > > > ?export prefix bindir sharedir sysconfdir
> > > >
> > > > --
> > > > 1.6.6.1
> > > 
> > > Sorry, I'd like to withdraw this patch.
> > > 
> > > I see I can achieve my desired ends without changing the behaviour
> > for
> > > others who expect the old behaviour,
> > 
> > The old behavior doesnt look very logical though, right?
> 
> No, not really. Well, logical for people quickly prototyping code
> on their own machines, but perf has grown beyond that.
> 
> However, I don't like my quick fix either, maybe I can come-up
> with something cleaner.

I've applied it meanwhile though, as /home/jkacur/home/jkacur/ is clearly a 
misbehavior :-)

	Ingo
