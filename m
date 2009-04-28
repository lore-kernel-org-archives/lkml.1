Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZD1Sy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZD1Sy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZD1SyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:54:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbZD1SyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:54:16 -0400
Date: Tue, 28 Apr 2009 11:48:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: fche@redhat.com (Frank Ch. Eigler)
Cc: zhaolei@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090428114827.afb8bbe6.akpm@linux-foundation.org>
In-Reply-To: <y0mr5zclmhi.fsf@ton.toronto.redhat.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
	<20090415011533.GI5968@nowhere>
	<20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com>
	<49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu>
	<49F1A59B.3080206@cn.fujitsu.com>
	<20090424130616.a3c217cb.akpm@linux-foundation.org>
	<y0mr5zclmhi.fsf@ton.toronto.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 13:24:57 -0400
fche@redhat.com (Frank Ch. Eigler) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > [...]  The patches introduce a moderate amount of tracing-specific
> > hooks into the core workqueue code, which inevitably increases the
> > maintenance load for that code.  It is important that it be
> > demonstrated that the benefts of the code are worth that cost.
> > Hence it is important that these benefits be demonstrated to us, by
> > yourself.  Please.  [...]
> 
> To be fair, if you ask for someone to specify and quantify the
> "benefits" side of this, shouldn't someone specify and quantify the
> "cost" side of this too?

Not if benefit==0 ;)

(Which I suspect will be close to the truth)

>  That way we would have something to compare.

Well, there are two aspects to this.  There's the immediate up-front
cost - a little added complexity, more code, etc.

But there's also the where-the-hell-is-this-all-going question.  Are we
going to end up with hundreds or thousands of tracepoints sprinkled all
over core kernel?  If so, what use are they?  What userspace tools will
be used to pull them into something useful?  Who will be developing
those tools and are they involved in the development of the
tracepoints?  Will this proliferation of static tracepoints actively
kill off the development and maturation of dynamic tracepoints?  If so,
is that good?


>From where I sit it looks like a mad scramble to sprinkle fairly random
tracepoints all over the place under the assumption that
this-may-be-useful-to-someone-one-day.  But of course, that means that
they many never be useful to anyone ever.

Part of this derives from the development approach.  With the various
tracers which we've developed in the past, the problem has been "I'm
working on subsystem X and I need help".  So the tracer is driven by a
particular development problem (original blktrace, ext3-debug, etc). 
This will axiomatically result in a tracer which is _useful_.

But in this case the approach is different - the problem statement is
"I need to add tracepoints to subsystem X".  It's not driven by any
particular development problem.  So there's no guarantee at all that the
end result will be _useful_ for anything!





