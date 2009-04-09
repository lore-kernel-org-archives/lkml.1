Return-Path: <linux-kernel-owner+w=401wt.eu-S935335AbZDIPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335AbZDIPao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935278AbZDIP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:29:49 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52661 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbZDIP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:29:48 -0400
Date: Thu, 9 Apr 2009 11:29:24 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Tracepoint: Make skb tracepoint use TRACE_EVENT macro
Message-ID: <20090409152924.GB5716@hmsreliant.think-freely.org>
References: <49DD90D2.5020604@cn.fujitsu.com> <20090409064041.GA6666@elte.hu> <20090409135626.GA5716@hmsreliant.think-freely.org> <alpine.DEB.2.00.0904091058200.15932@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904091058200.15932@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 11:05:08AM -0400, Steven Rostedt wrote:
> 
> On Thu, 9 Apr 2009, Neil Horman wrote:
> > 
> > I think this seems like a reasonable idea, as long as the sites that register a
> > hook for the tracepoint don't need to be updated (and it looks like they dont).
> > I do have one nit though: include/trace/skb.h has been emptied and now includes
> > include/trace/skb_event_types.h instead.  For the sake of neatness I'd say we
> > should either not make that change, and just dump the contents of
> > skb_event_types.h into trace/skb.h, or alternatively, remove trace/skb.h
> > entirely, and have files that need trace/skb.h include skb_event_types.h
> > instead.  Do that and it has my ACK.
> 
> Actually that trace/skb.h change is needed. It is not emptied, it still 
> has:
> 
>  #include <linux/skbuff.h>
>  #include <linux/tracepoint.h>
> 
> before the include of include/trace/skb_event_types.h
> 
> For ftrace to do its magic with the TRACE_EVENT macro, the file that 
> contains the TRACE_EVENT can not include tracepoint.h.  ftrace runs the 
> skb_event_types.h through a series of redefines of the TRACE_EVENT to 
> automate the creation of the directory and files in 
> debugfs/tracing/events/*.
> 
> We've already changed most of the files in include/trace/ to this format.
> 
> I hope we can still have your Ack without making your requested update.
> 
> Thanks,
> 
> -- Steve
> 
> 

That strikes me as overly complex and fragile.  One would think that ftrace
could include a first pass to scrub out that include prior to processing.
Having a utility reliant on the format of kernel header files, especially the
placement of includes is begging for somthing to break.

I'll ack it since the change I'm asking for is just cosmetic, and since any
reversions in this area are going to break ftrace in userspace rather than oops
the kernel, but I would really like to see ftrace hardened in such a way that
we don't need to be extra careful of include formatting when adding additional
tracepoints.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

