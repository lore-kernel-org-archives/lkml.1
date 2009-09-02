Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZIBB0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZIBB0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZIBB0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:26:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54765
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZIBB0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:26:31 -0400
Date: Tue, 01 Sep 2009 18:26:45 -0700 (PDT)
Message-Id: <20090901.182645.153420711.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: mingo@elte.hu, xiaoguangrong@cn.fujitsu.com, nhorman@tuxdriver.com,
       fweisbec@gmail.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
 TRACE_EVENT
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0908311407060.13931@gandalf.stny.rr.com>
References: <4A9B6AA7.5020508@cn.fujitsu.com>
	<20090831084922.GB25811@elte.hu>
	<alpine.DEB.2.00.0908311407060.13931@gandalf.stny.rr.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 31 Aug 2009 14:09:04 -0400 (EDT)

> 
> On Mon, 31 Aug 2009, Ingo Molnar wrote:
> 
>> 
>> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
>> 
>> > - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
>> >   like below:
>> 
>> I think as long as it does not touch tracing infrastructure (which 
>> your patches dont do in their current form) this should be 
>> done/merged via the networking tree.
> 
> I agree, all changes that are in include/trace/events/ and trace point 
> usage can stay within the subsystem tree.
> 
>> 
>> [ There might be some small collisions in define_trace.h (because
>>   these tracepoints move from legacy to new-style TRACE_EVENT() 
>>   form) but that's OK. ]
> 
> But changes to anything in include/trace or kernel/trace needs to go 
> throught the tracing subsystem. This includes a changes to define_trace.h.

This patch can't be split up, so I'm wondering how you suggest to
handle this patch given that you have declared that define_trace.h
changes aren't to go through the subsystem tree?

If we do the define_trace.h change only, we break the build
(lack of macro defined for the trace).

If we do only the other parts of his patch, we get a duplicate
definition.

And keep in mind that Neil and Xiao are probably going to want to do
work on top of this to the networking bits.  Thus if we put this patch
here into the tracing tree, I'll have to develop a dependency on the
tracing tree and I think that will go over like a fart in a spacesuit
with the -next crowd and Stephen Rothwell in particular.

Please advise.
