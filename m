Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZKPU60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZKPU60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZKPU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:58:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbZKPU6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:58:24 -0500
Date: Mon, 16 Nov 2009 21:58:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] perf buildid-list: New plumbing command
Message-ID: <20091116205820.GA6984@elte.hu>
References: <1258396365-29217-1-git-send-email-acme@infradead.org>
 <1258396365-29217-2-git-send-email-acme@infradead.org>
 <1258396365-29217-3-git-send-email-acme@infradead.org>
 <1258396365-29217-4-git-send-email-acme@infradead.org>
 <1258396365-29217-5-git-send-email-acme@infradead.org>
 <20091116185850.GB5293@nowhere>
 <20091116194104.GC12042@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116194104.GC12042@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Nov 16, 2009 at 07:58:52PM +0100, Frederic Weisbecker escreveu:
> > On Mon, Nov 16, 2009 at 04:32:45PM -0200, Arnaldo Carvalho de Melo wrote:
> > > With this we can list the buildids in a perf.data file so that we can
> > > pipe them to other, distro specific tools that from the buildids can
> > > figure out separate packages (foo-debuginfo) where we can find the
> > > matching symtabs so that perf report can do its job.
> > > E.g:
> > > [acme@doppio linux-2.6-tip]$ perf buildid-list | head -2
> > > 8e08b117e5458ad3f85da16d42d0fc5cd21c5869
> > > 520c2387a587cc5acfcf881e27dba1caaeab4b1f
> > > [acme@doppio linux-2.6-tip]$ perf buildid-list -v | head -2
> > > 8e08b117e5458ad3f85da16d42d0fc5cd21c5869 /sbin/init
> > > 520c2387a587cc5acfcf881e27dba1caaeab4b1f /lib64/ld-2.10.1.so
> > 
> > I would rather see the effect of this -v option as the default.
> > It's very useful to see the dso resolved but hashes alone
> > don't pay much.
> 
> I disagree, the main purpose of this command is equivalent to 'git
> rev-list':
> 
> [acme@doppio linux-2.6-tip]$ git rev-list HEAD^^..
> 089242a8c826aac1c827bb797475b9852fe0db49
> 18e3a75dc47d8397bbf0936ec8e3ebdecada7ba1
> [acme@doppio linux-2.6-tip]$ 
> 
> I.e. provide content keys that then will be used by distro specific
> porcelain to get the matching -debuginfo packages with the symtabs.

Hm, i'd say that's a (small) bug in Git.

Porcelain can add flags just fine to get 'raw' behavior - so in general 
we want to default the most human friendly parameters to the most 
human-readable output format.

	Ingo
