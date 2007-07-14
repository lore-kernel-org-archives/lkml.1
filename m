Return-Path: <linux-kernel-owner+w=401wt.eu-S1764322AbXGNTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764322AbXGNTu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbXGNTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:50:18 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46104 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbXGNTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:50:17 -0400
Subject: Re: [PATCH -rt 5/5] slub: -rt port
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714193817.GA108@tv-sign.ru>
References: <20070714175733.194012000@chello.nl>
	 <20070714175840.424675000@chello.nl> <20070714173950.GA806@tv-sign.ru>
	 <1184435417.5284.58.camel@lappy>  <20070714193817.GA108@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 21:49:49 +0200
Message-Id: <1184442589.5284.84.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 23:38 +0400, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:

> > Yeah, the function I copied this from: schedule_on_each_cpu() has a
> > comment to that effect.
> 
> Just in case, schedule_on_each_cpu() ptotects cpu_online_map with
> preempt_disable(), its problem is quite different.


I was schedule_on_each_cpu_wq() I copied, and that does not disable
preemption. Also, I'm failing to see how schedule_on_each_cpu() could
work with -rt, since __queue_work() takes a regular spinlock.

> > Any ideas on how to solve this?
> 
> Perhaps slab_cpuup_callback() can take flush_slab_mutex too, in that
> case cpu_online_map will be stable under flush_slab_mutex.

Right, I'll give that a try.

