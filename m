Return-Path: <linux-kernel-owner+w=401wt.eu-S933797AbZDBS3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797AbZDBS3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763084AbZDBS3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:29:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761003AbZDBS3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:29:15 -0400
Date: Thu, 2 Apr 2009 20:28:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: kerneltop: update to new
	ABI
Message-ID: <20090402182833.GA32407@elte.hu>
References: <20090402091319.407283141@chello.nl> <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org> <1238679305.3099.11.camel@ht.satnam> <1238680772.3099.13.camel@ht.satnam> <20090402181144.GB6340@elte.hu> <1238696579.3099.50.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238696579.3099.50.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Thu, 2009-04-02 at 20:11 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Thu, 2009-04-02 at 19:05 +0530, Jaswinder Singh Rajput wrote:
> > > > On Thu, 2009-04-02 at 12:03 +0000, Peter Zijlstra wrote:
> > > > > Commit-ID:  373b153677f26a263ef297d77a5e045a31f6486c
> > > > > Gitweb:     http://git.kernel.org/tip/373b153677f26a263ef297d77a5e045a31f6486c
> > > > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > AuthorDate: Thu, 2 Apr 2009 11:12:02 +0200
> > > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > > CommitDate: Thu, 2 Apr 2009 13:53:00 +0200
> > > > > 
> > > > > perf_counter: kerneltop: update to new ABI
> > > > > 
> > > > > Update to reflect the new record_type ABI changes.
> > > > > 
> > > > 
> > > > perfstat is still having many issues:
> > > > 
> > > > 1. 0:6: bus-cycles is not valid for AMD, so it fails
> > > > 
> > > > 2. ./perfstat -e 0:1,0:2,0:3,0:4,0:5,0:6 ls
> > > > can be replaced by ./perfstat -e 0:* ls
> > > > 
> > > > 3. Similarly ./perfstat -e 1:1,1:2,1:3,1:4,1:5,1:6 ls
> > > > can be replaced by ./perfstat -e 1:* ls
> > > > 
> > > > 4. All events can be replaced by ./perfstat -e * ls
> > > > 
> > > 
> > > 5. This command is invalid:
> > >   Sample output:
> > > 
> > >    $ ./perfstat -e 1 -e 3 -e 5 ls -lR /usr/include/ >/dev/null
> > 
> > yes, this should be fixed in perfstat: '-e 1' should be accepted as 
> > '-e 0:1'. Patches welcome.
> > 
> 
> if you treat '-e 1' as 'e 0:1' then how you will treat '-e 1:1' ?
>
> I think 'e 1:*' is better option to select all software events and 
> '-e 0:*' for all hardware events.

That is not what i suggested though. I suggested '-e 1' to mean to 
default to the more common case: hw counters. I.e.:

 -e 1    ==    -e 0:1
 -e 2    ==    -e 0:2
 -e 3    ==    -e 0:3
 ...

sw counters could be specified only via the longer form.

Anyway, most people will use symbolic names anyway (-e cycles, 
etc.), so i suspect the issue is mostly irrelevant.

	Ingo
