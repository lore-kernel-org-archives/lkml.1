Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZDVJ6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZDVJ6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZDVJ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:57:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZDVJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:57:56 -0400
Date: Wed, 22 Apr 2009 11:57:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro
Cc: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, rostedt@goodmis.org
Subject: Re: [Patch] mm tracepoints update
Message-ID: <20090422095727.GG18226@elte.hu>
References: <1240353915.11613.39.camel@dhcp-100-19-198.bos.redhat.com> <20090422095916.627A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422095916.627A.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > I've cleaned up the mm tracepoints to track page allocation and 
> > freeing, various types of pagefaults and unmaps, and critical 
> > page reclamation routines.  This is useful for debugging memory 
> > allocation issues and system performance problems under heavy 
> > memory loads.
> 
> In past thread, Andrew pointed out bare page tracer isn't useful. 

(do you have a link to that mail?)

> Can you make good consumer?

These MM tracepoints would be automatically seen by the 
ftrace-analyzer GUI tool for example:

  git://git.kernel.org/pub/scm/utils/kernel/ftrace/ftrace.git

And could also be seen by other tools such as kmemtrace. Beyond, of 
course, embedding in function tracer output.

Here's the list of advantages of the types of tracepoints Larry is 
proposing:

  - zero-copy and per-cpu splice() based tracing
  - binary tracing without printf overhead
  - structured logging records exposed under /debug/tracing/events
  - trace events embedded in function tracer output and other plugins
  - user-defined, per tracepoint filter expressions

I think the main review question is: are they properly structured 
and do they expose essential information to analyze behavioral 
details of the kernel in this area?

	Ingo
