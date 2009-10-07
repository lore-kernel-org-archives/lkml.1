Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbZJGGon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbZJGGon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZJGGon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:44:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415AbZJGGom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:44:42 -0400
Date: Wed, 7 Oct 2009 08:43:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf tools: Merge trace.info content into
	perf.data
Message-ID: <20091007064355.GA3283@elte.hu>
References: <20091006213643.GA5343@nowhere> <20091007062204.GE21673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007062204.GE21673@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > Here is an attempt to remove the trace.info file. It works well for 
> > me, the reason for it to be an RFC is that I have doubts about the 
> > backward compatibility.
> > 
> > A file created by perf after his patch is unsupported by previous 
> > version because the size of the headers have increased.
> 
> That's OK i think in terms of trace.info - trace.info was a temporary 
> hack to begin with.
> 
> > That said, it's two new fields that have been added in the end of the 
> > headers, and those could be ignored by previous versions if they just 
> > handled the dynamic header size and then ignore the unknow part. The 
> > offsets guarantee the compatibility.
> 
> Yes, that's how it should work.
> 
> > But previous versions handle the header size using its static size, 
> > not dynamic, then it's not backward compatible.
> > 
> > Anyway, I'm not sure exactly how to handle that.
> 
> That's a bug in the previous version - mind doing a standalone fix for 
> that so we can mark it Cc: stable?

Meanwhile i've applied your two patches - they are clear steps forward. 
We'll need the -stable fix so that the new perf.data can be read. (and 
even that only affects -R afaics - so normal perf record / perf report 
is compatible.)

Btw., we also need a patch for new perf to read older perf.data files 
[non-trace.info ones], as those are not working either:

 $ perf report
   Fatal: incompatible file format

( We dont want to push it - i.e. i dont think we need to support old
  perf.data + trace.info combos. )

	Ingo
