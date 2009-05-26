Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZEZVbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZEZVbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZEZVa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:30:58 -0400
Received: from www.tglx.de ([62.245.132.106]:51026 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbZEZVa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:30:57 -0400
Date: Tue, 26 May 2009 23:30:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Subject: Re: [PATCH 0/3] ftrace: add tracepoint for timer event
In-Reply-To: <4A1673AF.30508@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905262320330.1762@localhost.localdomain>
References: <4A1673AF.30508@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Xiao Guangrong wrote:
> We already have debugobject in timer to init/activate/deactivate/free,
> but it can't be covered function of there tracepoints, because:
> 1: We can't get timer's lifecycle information in userspace by debugobject,
>    it is necessary for system engineer to investigate system trouble caused
>    by using timer.
> 2: We can't get information of whole lifecycle of timer by debugobject, 
>    for example, deactivation of a timer.
> 3: There are many different tracing code in many kernel subsystem as
>    blktrace, debugobject, and tracepoint is designed as generic way
>    to unify these tracing way.

No. You can not unify debugobject into tracepoints. debugobjects is a
totally different beast. It's main purpose is to prevent undebugable
system crashes which we have seen several times e.g: freeing of an
active timer, reinitializing of an active timer ...

Dealing with these problems is not covered by tracepoints by any
means. The trace point does not prevent the system crash which happens
2 seconds after the fact that an active timer is kfree'd, debugobject
does and it points you to the exact place where the shit happens.

I'm not opposed to add tracepoints to the timer code at all. In fact I
appreciate that, but your idea of substituting debugobjects with
tracing is just plain wrong.

It's the other way round. tracing can reuse the existing debugobject
hooks to insert trace points, but it can not replace the functionality
at all.

Thanks,

	tglx
