Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZFXMM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZFXMM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZFXMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:12:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZFXMMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:12:47 -0400
Date: Wed, 24 Jun 2009 14:12:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Couder <christian.couder@gmail.com>
Cc: Junio C Hamano <gitster@pobox.com>,
       =?iso-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>,
       roel kluin <roel.kluin@gmail.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fread does not return negative on error
Message-ID: <20090624121226.GA20564@elte.hu>
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu> <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com> <4A3FB479.2090902@lsrfire.ath.cx> <7vhby64i8f.fsf@alter.siamese.dyndns.org> <20090624081819.GA10436@elte.hu> <c07716ae0906240353h67932054w3dc3ba6dbb864dff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c07716ae0906240353h67932054w3dc3ba6dbb864dff@mail.gmail.com>
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


* Christian Couder <christian.couder@gmail.com> wrote:

> Hi,
> 
> On Wed, Jun 24, 2009 at 10:18 AM, Ingo Molnar<mingo@elte.hu> wrote:
> >
> > * Junio C Hamano <gitster@pobox.com> wrote:
> >
> >> René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:
> >>
> >> > the following patch is for git.  I just removed the unneeded check for
> >> > res == 0 from your version.  Does it look OK?
> >>
> >> The patch looks good, and both of our in-tree users do error out
> >> when the returned value is 0 (imap-send.c checks with "<= 0" which
> >> looks a tad amateurish, though) correctly.
> >>
> >> Funny, there is no caller of this function in the original context
> >> this bug originally found, which I think is linux-2.6/tools/perf
> >> ;-).
> >
> > Hehe, yes :-)
> >
> > Background: when creating tools/perf/ i cherry-picked all the nice
> > Git libraries into tools/perf/util/, to give a standard environment
> > for all tooling things that might come up in the future.
> >
> > Some of those are not used yet but it looked more logical to pick up
> > whole pieces - some already gained uses. For example config.c is not
> > truly used yet, but very much expected to have a role in the future.
> >
> > ( The only invasive thing i had to do was the s/git_/perf_/ mass
> >  rename across all the files - having 'git_' in perf looked
> >  quite confusing. )
> >
> > And our general experience with the Git libraries in
> > tools/perf/util/* is: we love them!
> >
> > For example parse-options.c is a striking improvement compared to
> > getopt.h we used before, and all the other facilities are sane and
> > straight to the point as well. So in this sense 'perf' is an ...
> > interesting cross-discipline 'fork' of Git's generic libraries.
> >
> > The auto-generation of everything out of Documentation/*.txt is
> > another thing we picked up, and that's very nice too.
> >
> > One bookeeping issue: i found few explicit credits in those files -
> > so i noted in the changelog that i took them from Git and i noted
> > the specific upstream Git sha1 when i copied them. Would be nice to
> > update each file with names to make credit more explicit:
> 
> >From http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=tree;f=tools/perf;hb=HEAD
>
> it looks like there may be some other files like builtin-help.c 
> (and perhaps some files in perf/Documentation/ too though there 
> should be some AUTHOR information already in them).

Correct - the makefile and the whole glue code (and much else!) 
comes from Git - see commits:

 0780060: perf_counter tools: add in basic glue from Git
 d24e473: perf_counter: copy in Git's top Makefile

Any suggestions about how best credit everyone there? One central 
linux/tools/perf/CREDITS file?

	Ingo
