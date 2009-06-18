Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbZFROIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbZFROIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763380AbZFROIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:08:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53162 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762117AbZFROII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:08:08 -0400
Date: Thu, 18 Jun 2009 10:08:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] ftrace: change the export format of
	trace_kfree_skb()
Message-ID: <20090618140802.GA10300@hmsreliant.think-freely.org>
References: <4A2DF91F.7030906@cn.fujitsu.com> <20090609182730.GA6057@nowhere> <4A2F0F1D.7010101@cn.fujitsu.com> <20090610072618.GA6016@nowhere> <4A39B3E4.6060004@cn.fujitsu.com> <20090618103538.GA8978@hmsreliant.think-freely.org> <alpine.DEB.2.00.0906180847540.6890@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906180847540.6890@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 08:51:12AM -0400, Steven Rostedt wrote:
> 
> On Thu, 18 Jun 2009, Neil Horman wrote:
> > > 
> > > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > > index 1e8fabb..2496060 100644
> > > --- a/include/trace/events/skb.h
> > > +++ b/include/trace/events/skb.h
> > > @@ -7,6 +7,71 @@
> > >  #undef TRACE_SYSTEM
> > >  #define TRACE_SYSTEM skb
> > >  
> > > +#define protocol_name(protocol) { protocol, #protocol }
> > > +#define show_protocol_name(val)					\
> > > +	__print_symbolic(val,					\
> > 
> > Don't you need to include ftrace.h to pull in the __print_symbolic definition?
> > Or is that always guaranteed to be included from tracepoint.h?
> 
> Its use is in one of the fields of TRACE_EVENT that are only used by 
> define_trace.h. All other users will ignore it.
> 
> #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
> 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> 
> Only name, proto, args is used. The define_trace.h will include 
> trace/ftrace.h and that will use the struct, assign and print args.
> 
> So the answer is "no" ;-)
> 
> -- Steve
> 
> 

Ok, thanks
Acked-by: Neil Horman <nhorman@tuxdriver.com>

