Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZCFRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZCFRKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZCFRKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:10:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCFRKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:10:37 -0500
Date: Fri, 6 Mar 2009 18:10:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Patch] mm tracepoints
Message-ID: <20090306171016.GA32128@elte.hu>
References: <1233306324.11332.11.camel@nigel-laptop> <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com> <20090306105627.3EF0.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com> <20090306110423.GD21168@elte.hu> <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com> <20090306135547.GB21907@elte.hu> <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
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


* Larry Woodman <lwoodman@redhat.com> wrote:

> > Would that be useless or controversial? We know from 
> > vma->mapping which inode it maps to. Knowing which file is 
> > faulting in can be useful - especially when addresses are a 
> > moving target such as under PIE or with dlopen(), etc.
> > 
> > 	Ingo
> 
> Attached is the updated patch that applies and builds 
> correctly (sorry I missed the lockdep tracepoints that were 
> added at the last minute). [...]

Looks pretty good and useful to me. I've Cc:-ed more mm folks, 
it would be nice to hear their opinion about these tracepoints.

Andrew, Nick, Peter, what do you think?

About the motivation of these tracepoints: i suspect these 
tracepoints reflect your years-long experience in dealing with 
various MM regressions in the enterprise space and these 
tracepoints would help understand such regressions 
faster/easier?

> [...]  As far as the filename:offset is concerned I am working 
> on that.  Its not as simple as it looks because we have to 
> follow a variable list of structs that can be null terminated 
> several places along the way.

It's definitely not simple! I dont think it should be in this 
base patch at all - it should be an add-on.

	Ingo
