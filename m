Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZDOGri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZDOGri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZDOGr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:47:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZDOGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:47:28 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] tracing, workqueuetrace: Make workqueue tracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090413141341.GB5977@nowhere>
References: <49E28D4B.5040802@cn.fujitsu.com> <20090413141341.GB5977@nowhere>
Message-Id: <20090415154059.AC49.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 15:47:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > +	TP_fast_assign(
> > +		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
> 
> 
> 
> This is not about your patch but I see this pattern happen often. We should
> start think about a way to use tracing_record_cmdline for that.

I guess two movq isn't expensive than tracing_record_cmdline ;)


> > +	TP_printk("thread=%s:%d work=%p func=%p", __entry->thread_comm,
> 
> These pointer addresses are not very useful to display.
> We can zap work and display the func as a %pF.
> 
> Not related to your patch: only the name of the func is useful,
> not its asm offset. A format for raw func name without offset would
> start to become very handy. I remember Andrew talked about that by the past.
> 
> I wonder which format we could use for that. %pf ?

perhaps, static function need offset...




