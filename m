Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYIVMHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYIVMHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYIVMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:07:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYIVMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:07:08 -0400
Date: Mon, 22 Sep 2008 08:07:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: How how latent should non-preemptive scheduling be?
In-Reply-To: <20080922115749.GE14301@elte.hu>
Message-ID: <alpine.DEB.1.10.0809220804090.14496@gandalf.stny.rr.com>
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no>
 <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Sep 2008, Ingo Molnar wrote:
> * Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> >>
> >> sounds like potential SMM triggered latencies.
> >
> > I have just gone away and read about the SMM ( 
> > http://blogs.msdn.com/carmencr/archive/2005/08/31/458609.aspx ). If 
> > you're right there is pretty much nothing that can be done about the 
> > problem : (
> 
> well, since they went away after you enabled CONFIG_PREEMPT=y, they are 
> definitely in-kernel latencies, not any external SMM latencies.
> 
> I.e. they are inherently fixable. Could you enable:
> 
>   CONFIG_DYNAMIC_FTRACE=y
>   CONFIG_FTRACE_MCOUNT_RECORD=y
> 
> that should make the traces a lot more verbose - every kernel function 
> executed in the latency path will be logged. That way we'll be able to 
> say which one takes that long.
> 
> note, you might have to increase /debug/tracing/trace_entries to get a 
> long enough trace to capture the relevant portion of the latency.

Also note, to modify trace_entries, you must be in the none (nop?) tracer, 
otherwise the size will not be effected.

If you find the trace is also too big, you can echo a list of functions 
into:

  /debug/tracing/set_ftrace_notrace

to not trace those functions. using '>' will remove any existing function 
in that file, but using '>>' will append functions to the file.

For a list of functions that you can add, see:

  /debug/tracing/available_filter_functions

-- Steve

