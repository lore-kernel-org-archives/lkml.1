Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZBYIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZBYIOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760812AbZBYINt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:13:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53707 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760670AbZBYINs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:13:48 -0500
Date: Wed, 25 Feb 2009 09:11:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225081118.GC15303@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224203308.8d623e0b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 24 Feb 2009 23:08:56 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Gad, what a lot of stuff.
> > > 
> > > Use strncpy_from_user()?
> > > 
> > > Use strstrip()?
> > > 
> > > Why do we care about leading and trailing whitespace - user error!
> > 
> > This is because i want:
> > 
> >  cat available_events > set_event
> > 
> > to work.
> 
> :(
> 
> Why on earth do we keep on putting all these pretty-printers 
> and pretty-parsers into the kernel?  I mean, how hard is it 
> for userspace to read a text file, do some basic substitutions 
> and print it out again?

Note that there's no mandatory user-space component here - the 
final destination is the kernel developer's eyes in 90% of the 
cases. These traces get pasted into email, etc. etc.

So leading spaces, meaningful formatting and general hands-on 
usability is important. [ I know, it's a strange concept in the 
kernel, we tend to have a perversion for the most unusable and 
most inconsistent user interfaces ;-) ]

It's also a balancing act. We dont want to put all of TeX into 
the kernel obviously. Nor do we want the default to be the 
opposite end of the spectrum: to output raw binary records. So 
we find some middle ground. That middle ground is inluenced by 
the developers using this stuff.

	Ingo
