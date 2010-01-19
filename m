Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458Ab0ASIlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0ASIlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0ASIlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:41:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:56011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab0ASIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:41:13 -0500
Subject: Re: [PATCH 1/3] perf_event: fix race in
 perf_swevent_get_recursion_context()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B556118.7020502@cn.fujitsu.com>
References: <4B54654A.4090601@cn.fujitsu.com>
	 <1263822958.4283.560.camel@laptop>  <4B556118.7020502@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:41:03 +0100
Message-ID: <1263890463.4283.636.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 15:36 +0800, Xiao Guangrong wrote:
> Hi Peter,
> 
> Peter Zijlstra wrote:
> > On Mon, 2010-01-18 at 21:42 +0800, Xiao Guangrong wrote:
> >> It only disable preemption in perf_swevent_get_recursion_context()
> >> it can't avoid race of hard-irq and NMI
> >>
> >> In this patch, we use atomic operation to avoid it and reduce
> >> cpu_ctx->recursion size, it also make this patch no need diable
> >> preemption
> > 
> > Uhm why?
> > 
> > This patch looks terminally broken
> 
> Please see my explanation in another mail:
> http://lkml.org/lkml/2010/1/18/501

Still its not going to happen, we need those 4 recursion contexts.
Otherwise we could not receive a software event from an IRQ while we are
processing a software event from process context, etc.

