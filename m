Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYGQGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYGQGZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYGQGZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:25:32 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:37187 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751864AbYGQGZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:25:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OjyGE4xyL2K8qf2EFZFeMs3m0/bAmtWG5XQZIx6TRMvq956spveruCY/g2itppz7ieiAw7CaJx1lJslrIW8x4LrN9vb6xN1i6zfJEj8TvH3WYgee21tHr2vZPZS+WtgRKdxiZPkB8JCGuumq1wkPlJS6pGrKGtJP8MwFV9/WePA=  ;
X-YMail-OSG: _sUKu.kVM1mZ8ISAjFxclMARH259Hm..MUKTyy46kwmSsBkkkONnmVyHaMxPA2VCNL6wu3BDWQ0vTtREp3ozlAj1iDsxcuG7A5Uef634XLteNuU8p2a4Gjo.FtJD3afk1Ds-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 09/17] LTTng instrumentation - filemap
Date: Thu, 17 Jul 2008 16:25:24 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
References: <20080715222604.331269462@polymtl.ca> <20080715222748.002421557@polymtl.ca>
In-Reply-To: <20080715222748.002421557@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171625.25302.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 08:26, Mathieu Desnoyers wrote:
> Instrumentation of waits caused by memory accesses on mmap regions.
>
> Those tracepoints are used by LTTng.
>
> About the performance impact of tracepoints (which is comparable to
> markers), even without immediate values optimizations, tests done by Hideo
> Aoki on ia64 show no regression. His test case was using hackbench on a
> kernel where scheduler instrumentation (about 5 events in code scheduler
> code) was added. See the "Tracepoints" patch header for performance result
> detail.

BTW. this sort of test is practically useless to measure overhead. If
a modern CPU is executing out of primed insn/data and branch prediction
cache, then yes this sort of thing is pretty well free.

I see *real* workloads that have got continually and incrementally slower
eg from 2.6.5 to 2.6.20+ as "features" get added. Surprisingly, none of
them ever showed up individually on a microbenchmark.

OK, for this case if you can configure it out, I guess that's fine. But
let's not pretend that adding code and branches and function calls are
ever free.
