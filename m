Return-Path: <linux-kernel-owner+w=401wt.eu-S1751397AbZLVIYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbZLVIYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZLVIYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:24:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZLVIYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:24:40 -0500
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B305680.4090304@cn.fujitsu.com>
References: <4B2F1543.8020300@cn.fujitsu.com>
	 <20091221064356.GA2378@elte.hu>  <4B2F2588.8070501@cn.fujitsu.com>
	 <1261406427.4314.155.camel@laptop>
	 <1261410984.25193.8.camel@gandalf.stny.rr.com>
	 <4B305680.4090304@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 09:23:54 +0100
Message-ID: <1261470234.4937.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 13:17 +0800, Li Zefan wrote:

> Looking into sched_clock.c, seems the only place that can trigger lockdep
> is the local_irq_* in cpu_clock(), though I'm not sure for architecture-
> specific sched_clock().

But why would you want to do that? that reduces the lockdep coverage for
no good reason, just fix up the tracer.

