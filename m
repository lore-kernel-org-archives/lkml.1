Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0BAI4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:56:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0BAI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:56:35 -0500
Subject: Re: [PATCH] perf tools: fix write_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100131083234.GA12637@elte.hu>
References: <4B570657.5090105@cn.fujitsu.com>
	 <20100131083234.GA12637@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:56:13 +0100
Message-ID: <1265014573.24455.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 09:32 +0100, Ingo Molnar wrote:
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
> > We parse the event while it's read from mmap buffer in
> > write_event(), but sometimes the event will straddles the
> > mmap boundary, we should handle this case
> > 
> > And if we record events(such as perf kmem/sched) for long
> > times, Ctrl + C can't interrupt it just for this reason
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  tools/perf/builtin-record.c |   62 +++++++++++++++++++++++++++++++++---------
> 
> Note, i've reverted the original instead, via:
> 
>   a8e6f73: Revert "perf record: Intercept all events"
> 
> As Peter said it, it is fundamentally wrong for perf record to touch the data 
> stream in the common case. Arnaldo, cannot we use some other method for perf 
> archive's needs? Worst-case we can do an optional parsing of the data stream 
> although we should first try hard to find a generic method ...

Arnaldo posted patches for this last friday somewhere, it might turn out
you already found them (reading mail by date order here).

