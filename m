Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZEADdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZEADdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZEADdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZEADdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:33:32 -0400
Date: Thu, 30 Apr 2009 23:33:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] ring-buffer: add counters for commit overrun and
 nmi dropped entries
In-Reply-To: <20090430202242.aeeb1954.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904302331230.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022400.894326175@goodmis.org> <20090430200034.fb794702.akpm@linux-foundation.org> <alpine.DEB.2.00.0904302311320.20374@gandalf.stny.rr.com> <20090430202242.aeeb1954.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Apr 2009, Andrew Morton wrote:

> On Thu, 30 Apr 2009 23:11:52 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > hm.  Four functions in a row, all of which differ in but a single line.
> > > 
> > > unsigned long
> > > ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
> > > {
> > > 	return some_common_function(buffer, cpu)->commit_overrun;
> > > }
> > > 
> > > ?
> > 
> > But that actually takes thought. I like my cut and paste ;-)
> 
> Well, we all like your cut-n-paste, Steve.

It helps with my commit count.

> 
> Should you decide to retire the paste pot, and if you can bear to move
> `struct ring_buffer' into a header, these four functions could be made
> static inlines, with pleasant runtime results.

Well, the only users of these functions are those that output to user 
land. The latency format and the stat file. static inlines wont help much 
with performance there.

But I do think it is cleaner to consolidate them.

Thanks,

-- Steve

