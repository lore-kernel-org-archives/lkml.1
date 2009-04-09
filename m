Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZDIPFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZDIPFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZDIPFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:05:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46431 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZDIPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:05:10 -0400
Date: Thu, 9 Apr 2009 11:05:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Neil Horman <nhorman@tuxdriver.com>
cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Tracepoint: Make skb tracepoint use TRACE_EVENT macro
In-Reply-To: <20090409135626.GA5716@hmsreliant.think-freely.org>
Message-ID: <alpine.DEB.2.00.0904091058200.15932@gandalf.stny.rr.com>
References: <49DD90D2.5020604@cn.fujitsu.com> <20090409064041.GA6666@elte.hu> <20090409135626.GA5716@hmsreliant.think-freely.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 9 Apr 2009, Neil Horman wrote:
> 
> I think this seems like a reasonable idea, as long as the sites that register a
> hook for the tracepoint don't need to be updated (and it looks like they dont).
> I do have one nit though: include/trace/skb.h has been emptied and now includes
> include/trace/skb_event_types.h instead.  For the sake of neatness I'd say we
> should either not make that change, and just dump the contents of
> skb_event_types.h into trace/skb.h, or alternatively, remove trace/skb.h
> entirely, and have files that need trace/skb.h include skb_event_types.h
> instead.  Do that and it has my ACK.

Actually that trace/skb.h change is needed. It is not emptied, it still 
has:

 #include <linux/skbuff.h>
 #include <linux/tracepoint.h>

before the include of include/trace/skb_event_types.h

For ftrace to do its magic with the TRACE_EVENT macro, the file that 
contains the TRACE_EVENT can not include tracepoint.h.  ftrace runs the 
skb_event_types.h through a series of redefines of the TRACE_EVENT to 
automate the creation of the directory and files in 
debugfs/tracing/events/*.

We've already changed most of the files in include/trace/ to this format.

I hope we can still have your Ack without making your requested update.

Thanks,

-- Steve

