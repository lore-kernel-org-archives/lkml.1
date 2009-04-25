Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZDYC3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZDYC3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 22:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZDYC3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 22:29:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbZDYC3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 22:29:39 -0400
Date: Fri, 24 Apr 2009 19:24:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090424192415.1291a76b.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904242149150.24293@gandalf.stny.rr.com>
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
	<20090424182821.8263f445.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0904242149150.24293@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 22:00:20 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> I agree that we need to be frugal with the addition of trace points. But 
> I don't think the bugs that can be solved with this is always reproducible 
> by the developer.
> 
> If you have a distribution kernel that is running at a customers location, 
> you may not have the privilege of shutting down that kernel, patching the 
> code, recompiling and booting up this temporary kernel. It would be nice 
> to have strategic locations in the kernel where we can easily enable a 
> trace point and monitor what is going on.
> 
> If the customer calls and tells you there's some strange performance 
> issues when running such and such a load, it would be nice to look at 
> things like workqueues to analyze the situation.

Would it?  What's the probability that anyone anywhere will *really*
solve an on-site problem using workqueue tracepoints?  Just one person?

I think the probability is quite small, and I doubt if it's high enough
to add permanent code to the kernel.

Plus: what we _really_ should be looking at is

p(someone uses this for something) -
	p(they could have used a kprobes-based tracer)

no?

> Point being, the events are not for me on the box that runs my machines.
> Hell, I had Logdev for 10 years doing that for me. But now to have 
> something that is running at a customers site with extremely low overhead 
> that we can enable when problems arise. That is what makes this worth 
> while.
> 
> Note, when I was contracting, I even had logdev prints inside the 
> production (custom) kernel that I could turn on and off. This was exactly 
> for this purpose. To monitor what is happening inside the kernel when in 
> the field.

We seem to be thrashing around grasping at straws which might justify
the merging of these tracing patches.  It ain't supposed to be that way.
