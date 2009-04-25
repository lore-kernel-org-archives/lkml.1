Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZDYBjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZDYBjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbZDYBeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:34:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760702AbZDYBeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:34:10 -0400
Date: Fri, 24 Apr 2009 18:28:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: zhaolei@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090424182821.8263f445.akpm@linux-foundation.org>
In-Reply-To: <20090425003702.GC6658@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
	<20090415011533.GI5968@nowhere>
	<20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com>
	<49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu>
	<49F1A59B.3080206@cn.fujitsu.com>
	<20090424130616.a3c217cb.akpm@linux-foundation.org>
	<20090424225909.GA6658@nowhere>
	<20090424162056.45907fef.akpm@linux-foundation.org>
	<20090425003702.GC6658@nowhere>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 02:37:03 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> I discovered it with this tracer. Then it brought me to
> write this patch:
> 
> http://lkml.org/lkml/2009/1/31/184
> 
> ...
> 
> Still with these same observations, I wrote this another one:
> 
> http://lkml.org/lkml/2009/1/26/363

OK, it's great that you're working to improve the workqueue code.  But
does this justify permanently adding debug code to the core workqueue
code?  In fact, because you've discovered these problem, the reasons
for adding the debug code have lessened!

What we need are curious developers looking into how well subsystems
are performing and how well callers are using them.  Adding fairly
large amounts of permanent debug code into the core subsystems is a
peculiar way of encouraging such activity.

If a developer is motivated to improve (say) workqueues then they will
write a bit of ad-hoc code, or poke at it with systemtap or will
maintain a private ftrace patch - that's all pretty simple stuff for
such people.

So what is the remaining case for adding these patches?  What I see is

a) that their presence will entice people to run them and maybe find
   some problems and

b) the workqueue-maintainer's task is lessened a bit by not having
   to forward-port his debugging patch.

I dunno, it all seems a bit thin to me.  Especially when you multiply
it all by nr_core_subsystems?

