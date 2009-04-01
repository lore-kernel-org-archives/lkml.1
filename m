Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbZDARsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbZDARsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZDARsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:48:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZDARsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:48:21 -0400
Date: Wed, 1 Apr 2009 19:47:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
Message-ID: <20090401174720.GA19225@elte.hu>
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu> <49D37584.50208@redhat.com> <20090401142711.GG18677@elte.hu> <49D3A708.9080501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D3A708.9080501@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> >> I agreed. Fortunately, Jim Keniston and I wrote an x86 
> >> instruction decoder :-) which has been made originally for 
> >> uprobe andd kprobes jump-optimizer.
> >>
> >> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> > 
> > looks cool. Needs to be put somewhere in arch/x86/lib/, provided 
> > as a generic facility, with a Kconfig variable that says that 
> > the architecture supports it and then the kprobes-tracer could 
> > make immediate use of it, right?
> 
> Yeah, I'd rather add a safety checker in kprobes-x86 itself, 
> because sometimes it has to fixup instructions modified by 
> previous kprobes.

Oh, certainly! I didnt know how much you wanted to check things on 
the kprobes side but by all means please add it there too, it will 
be for the better.

A clear and actionable debug message to the syslog is important for 
the case where the decoder rejects an action. This is especially 
important for the kprobes side - we dont want silent breakage of 
tools.

	Ingo
