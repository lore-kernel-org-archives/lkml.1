Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbZAPQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbZAPQC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZAPQCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:02:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbZAPQCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:02:13 -0500
Date: Fri, 16 Jan 2009 17:02:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116160202.GA15209@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com>
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
> On Fri, 16 Jan 2009, Ingo Molnar wrote:
> > > 
> > > But I do notice that not all functions produce a valid stack trace. 
> > > Maybe it would be better to add that api :-?
> > 
> > yes - i think that API would be more intuitive, and that way people could 
> > mix more interesting functions (with stack traces) with less important 
> > functions (no stack traces).
> 
> Ah, that's the point. We can't mix and match on these. Either all 
> functions that are traced do the stack trace, or none do. This is where 
> the new api may be confusing. [...]

that would be confusing indeed.

> [...] We can register a function to be traced via the function pointer, 
> and we can pick which functions to trace, but we can not separate out 
> different functions for different traces.

Why not? We could have a hash of all traced functions with metadata 
attached. Since patching functions in/out would be a relatively rare 
operation, this would be a highly efficient read-mostly hash.

	Ingo
