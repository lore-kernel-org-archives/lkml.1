Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZD0FvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZD0FvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZD0Fuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:50:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbZD0Fuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:50:51 -0400
Date: Sun, 26 Apr 2009 22:44:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090426224450.8ea9f724.akpm@linux-foundation.org>
In-Reply-To: <20090426104747.GA5983@elte.hu>
References: <20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com>
	<49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu>
	<49F1A59B.3080206@cn.fujitsu.com>
	<20090424130616.a3c217cb.akpm@linux-foundation.org>
	<20090424225909.GA6658@nowhere>
	<20090424162056.45907fef.akpm@linux-foundation.org>
	<20090425003702.GC6658@nowhere>
	<20090424182821.8263f445.akpm@linux-foundation.org>
	<20090426104747.GA5983@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 12:47:47 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 25 Apr 2009 02:37:03 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > I discovered it with this tracer. Then it brought me to
> > > write this patch:
> > > 
> > > http://lkml.org/lkml/2009/1/31/184
> > > 
> > > ...
> > > 
> > > Still with these same observations, I wrote this another one:
> > > 
> > > http://lkml.org/lkml/2009/1/26/363
> > 
> > OK, it's great that you're working to improve the workqueue code.  
> > But does this justify permanently adding debug code to the core 
> > workqueue code? [...]
> 
> Andrew - but this is not what you asked originally. Here's the 
> exchange, not cropped:
> 
> > > > So this latest patchset provides all these required 
> > > > informations on the events tracing level.
> > >  Well.. required by who?
> > >
> > > I don't recall ever seeing any problems of this nature, nor 
> > > patches to solve any such problems.
> 
> And Frederic replied that there's three recent examples of various 
> patches and problem reports resulting out of the workqueue 
> tracepoints.
> 
> Now you argue 'yes, there might have been an advantage but it's not 
> permanent' - which appears to be a somewhat shifting position 
> really. I dont think _our_ position has shifted in any way - please 
> correct me if i'm wrong ;-)

My point, as I'm sure you fully understand, is that this feature is
unlikely to see sufficient use as to warrant its inclusion.

> And i'm, as the original author of the kernel/workqueue.c code 
> (heck, i even coined the 'workqueue' term - if that matters)

Most workqueue work lately has come from Oleg.  I'm unaware that he has
expressed an interest in this feature?  Oleg, would it have been useful
in any of the work you've done?

> And the thing is, the workqueue code has been pretty problematic 
> lately - with lockups and other regressions. It's a pretty 'opaque' 
> facility that _hides_ what goes on in it - so more transparency 
> might be a good answer just on that basis alone.

OK, so there's a test case.  How many of the problems which we've
recently found and fixed in the workqueue would have been more easily
found and fixed had this feature been available?

Zero, methinks.

> Secondly, if we discount the (fairly standard) off-site tracepoints, 
> is not "large amount of debug code" - the tracepoints are completely 
> off site and are not a worry as long as the tracepoint arguments are 
> kept intact. The bits in kernel/workqueue.c are on the 26 lines flux 
> range:

Multiplied by gawd-knows-how-many other such subsystems.
