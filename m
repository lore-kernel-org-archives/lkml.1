Return-Path: <linux-kernel-owner+w=401wt.eu-S965141AbYD1UeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbYD1UeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbYD1UeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:34:14 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:65167 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476AbYD1UeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:34:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAGvRFUhMROPA/2dsb2JhbACBU6pu
Date: Mon, 28 Apr 2008 16:34:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftrace and debugfs weird interaction
Message-ID: <20080428203411.GC27154@Krystal>
References: <20080426185403.GA22522@Krystal> <20080428153956.GH18776@elte.hu> <20080428223535.4fe2aeca@daedalus.pq.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080428223535.4fe2aeca@daedalus.pq.iki.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:33:15 up 59 days, 16:44,  5 users,  load average: 0.59, 0.57,
	0.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Paalanen (pq@iki.fi) wrote:
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Hi,
> > > 
> > > When trying to figure out what was going on with the sched tracer
> > > "tracing_enabled" file (sched-devel.git tree), I fell on this strange
> > > behavior :
> > > 
> > > echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write
> 
> Wait a minute, are you literally running the command:
> echo 1>tracing_enabled
> 
> If you are, you just echoed only a newline and directed stdout, stream 1,
> to the file. No? :-)
> 
> Could you try with a space:
> echo 1 > tracing_enabled
> 
> > > callback. However, sending garbage, e.g. echo s> tracing_enabled,
> > > correctly sends the 's' character down the chain. echo 0>tracing_enabled
> > > sometimes results in the callback not even being called.
> 
> Stream 0 is stdin, so... not sure what this would do. Probably nothing,
> just like you experienced.
> 

*duh*. Ok. That wasn't smart. You spotted the problem. Thanks a lot :)

Mathieu

> 
> Thanks.
> 
> -- 
> Pekka Paalanen
> http://www.iki.fi/pq/

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
