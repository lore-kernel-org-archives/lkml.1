Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYLDIk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYLDIk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYLDIkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:40:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYLDIkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:40:14 -0500
Date: Thu, 4 Dec 2008 09:39:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, arjan@infradead.org,
       dave@linux.vnet.ibm.com, containers@lists.osdl.org,
       ebiederm@xmission.com, sukadev@linux.vnet.ibm.com, serue@us.ibm.com,
       srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-ID: <20081204083917.GF32594@elte.hu>
References: <20081203203656.776893226@goodmis.org> <20081203203828.920111079@goodmis.org> <20081203130741.473c1262.akpm@linux-foundation.org> <alpine.DEB.1.10.0812031608560.29045@gandalf.stny.rr.com> <20081203133242.4e80bbe6.akpm@linux-foundation.org> <alpine.DEB.1.10.0812031635060.28153@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812031635060.28153@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 3 Dec 2008, Andrew Morton wrote:
> 
> > On Wed, 3 Dec 2008 16:10:38 -0500 (EST)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > +
> > > > > +	seq_printf(m, "%s\n", str);
> > > > 
> > > > Can we use %pF here?
> > > 
> > > If there's a way to not print the "+offset".
> > 
> > Could be added, I guess.  I wonder if it would be
> > reused elsewhere.
> 
> There's lots of places in ftrace that would use it, and probably clean 
> up a bunch of code in the process.

Well, we do eventually want to have a trace_option that extends all 
function names with the +offset/size portion - and one that switches them 
to raw RIPs.

In rare occasions, when the same function has multiple call sites of the 
same child function, it can be useful. I ran into such scenarios with the 
latency tracer and it had this capability to do 'verbose' symbol 
printing.

So plain %pF wont cut it - please abstract out the "print function symbol 
string" bit within the ftrace infrastructure.

And the default trace_option for this should be to print without 
+offset/size spam, emphatically :)

	Ingo
