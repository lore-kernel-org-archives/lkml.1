Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZIALEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZIALEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZIALEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:04:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33454 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZIALEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:04:50 -0400
Date: Tue, 1 Sep 2009 07:04:36 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
	TRACE_EVENT
Message-ID: <20090901110436.GA10918@hmsreliant.think-freely.org>
References: <4A9B6AA7.5020508@cn.fujitsu.com> <alpine.DEB.2.00.0908311402150.13931@gandalf.stny.rr.com> <4A9C73A4.20003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9C73A4.20003@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 09:06:44AM +0800, Xiao Guangrong wrote:
> 
> 
> Steven Rostedt wrote:
> > On Mon, 31 Aug 2009, Xiao Guangrong wrote:
> > 
> >> - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
> >>   like below:
> >>
> >>    sshd-2503  [000]    71.920846: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
> >>    sshd-2503  [000]    72.020291: napi_poll: ifname=eth0 state=0 weigth=16 poll=pcnet32_poll
> >>    sshd-2503  [000]    72.020418: napi_poll: ifname=eth0 state=NAPI_STATE_SCHED weigth=16 poll=pcnet32_poll
> >>
> >> - Remove the "DECLARE_TRACE" definiens in include/trace/define_trace.h,
> >>   because TRACE_EVENT not use it
> > 
> > The above really needs to be in a separate patch, since it is a tracing 
> > infrastructure change.
> > 
> 
> Hi Steven,
> 
> We can't break this patch into two patches, because it's has redefined 'DECLARE_TRACE'
> in include/trace/define_trace.h, like below:
> 
> 1: if we remove 'DECLARE_TRACE' first, then NAPI's tracepoint can't define tracepoint
>    (it's a NAPI tracepoint's bug,
>     see my previous patch: http://marc.info/?l=linux-kernel&m=125118032931716&w=2)
> 
> 2: if we convert NAPI's tracepoint first, it can't include more TRACE_EVENT .h files in
>    one .c file, the compiler will complain with variables redefined:
> 
> include/trace/events/napi.h:15: error: redefinition of ‘__tpstrtab_napi_poll’
> include/trace/events/napi.h:15: error: previous definition of ‘__tpstrtab_napi_poll’ was here
> include/trace/events/napi.h:15: error: redefinition of ‘__tracepoint_napi_poll’
> include/trace/events/napi.h:15: error: previous definition of ‘__tracepoint_napi_poll’ was here
> In file included from include/trace/ftrace.h:644,
> 
> So, I think we do better fix this bug early, then other people can go on his work on ftrace.
> 
> Hi Neil,
> 
> How do you think about this patch, can you give me some comments?
> 
For the things that I use the napi_poll traepoint for, this is all  fine by me,
so ack as far as that goes, but I'm probably not qualified to comment on the
tracepoint infrastructure changes you've made (the recent skb ftracer argument
is like a good indicator of that :) )

Neil

> 
> Thanks,
> Xiao
> 
> 
