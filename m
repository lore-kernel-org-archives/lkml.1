Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYJQXaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYJQXaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYJQX3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:29:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:53820 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYJQX3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:29:54 -0400
X-BigFish: VPS-38(zz1dbaM1432R98dR936eQ1805Mzzzz5a6ciz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48F91FE1.6030902@am.sony.com>
Date: Fri, 17 Oct 2008 16:29:37 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?77+9?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch
 entry
References: <48F10A9D.3030705@gmail.com>	 <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com>	 <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>	 <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>	 <c62985530810120429u774c7eefm44bef7d8b4199115@mail.gmail.com> <c62985530810130110r5ba73d04wec70e597abd48126@mail.gmail.com>
In-Reply-To: <c62985530810130110r5ba73d04wec70e597abd48126@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 17 Oct 2008 23:29:38.0649 (UTC) FILETIME=[390FE490:01C930B0]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

� wrote:
> 2008/10/12 Fr�d�ric Weisbecker <fweisbec@gmail.com>:
>> 2008/10/12 Steven Rostedt <rostedt@goodmis.org>:
>>> You can tap into the context switch trace_point too, and have that record
>>> a special trace entry for you instead.
> 
> Another thing I could do: when a sched switch entry occurs, I could
> send a special timestamp entry that
> fits my needs just before the commit of the sched entry, only if the
> current tracer is the boot tracer. This way I can output
> the appropriate timestamp just before output the sched entry.
> 
> What do you think?

I may have lost context here, but what's the purpose of the
extra timestamp again?  If it's just to have zero-based
timestamps on the ultimate output, can't you just put a single
special "start" timestamp in the trace log.  Then that can
be subtraced from all tracer-generated stamps in post-processing.
I'm not familiar enough with the tracer to know if the
post-processing is done in kernel space.  But in any event
you could use something like scripts/show_delta to get
relative timestamps (in user space).  Right now, scripts/show_delta
doesn't act like a filter - I'll have to look at that.

Sorry if I'm just adding noise...
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

