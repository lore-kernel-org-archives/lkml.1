Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZCXSks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZCXSks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZCXSkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:40:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZCXSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:40:39 -0400
Date: Tue, 24 Mar 2009 19:39:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 8/9] LTTng instrumentation - filemap
Message-ID: <20090324183940.GI31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160149.029092843@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160149.029092843@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Index: linux-2.6-lttng/mm/filemap.c

> +DEFINE_TRACE(wait_on_page_start);
> +DEFINE_TRACE(wait_on_page_end);

These are extremely incomplete - to the level of being useless.

To understand the lifetime of the pagecache, the following basic 
events have to be observed and instrumented:

 - create a new page
 - fill in a new page
 - dirty a page [when we know this]
 - request writeout of a page
 - clean a page / complete writeout
 - free a page due to MM pressure
 - free a page due to truncation/delete

The following additional events are useful as well:

 - mmap a page to a user-space address
 - copy a page to a user-space address (read)
 - write to a page from a user-space address (write)
 - unmap a page from a user-space address
 - fault in a user-space mapped pagecache page

optional:
   - shmem attach/detach events
   - shmem map/unmap events
   - hugetlb map/unmap events

I'm sure i havent listed them all. Have a look at the function-graph 
tracer output to see what kind of basic events can happen to a 
pagecache page.

	Ingo
