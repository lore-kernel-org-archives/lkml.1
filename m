Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0AaIdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0AaIdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907Ab0AaIdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:33:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0AaIdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:33:09 -0500
Date: Sun, 31 Jan 2010 09:32:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: fix write_event()
Message-ID: <20100131083234.GA12637@elte.hu>
References: <4B570657.5090105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B570657.5090105@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> We parse the event while it's read from mmap buffer in
> write_event(), but sometimes the event will straddles the
> mmap boundary, we should handle this case
> 
> And if we record events(such as perf kmem/sched) for long
> times, Ctrl + C can't interrupt it just for this reason
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/builtin-record.c |   62 +++++++++++++++++++++++++++++++++---------

Note, i've reverted the original instead, via:

  a8e6f73: Revert "perf record: Intercept all events"

As Peter said it, it is fundamentally wrong for perf record to touch the data 
stream in the common case. Arnaldo, cannot we use some other method for perf 
archive's needs? Worst-case we can do an optional parsing of the data stream 
although we should first try hard to find a generic method ...

	Ingo
