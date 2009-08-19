Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZHSBXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZHSBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZHSBXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:23:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:5821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZHSBXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OzasKoO9ditN8+XZYE95G7xr+Js0scEFXskwx2KThF30ivTovLsM+ev1pFSLJ4y2ov
         QTlaj9v4nLNqqyEqN0tg5lHqSDrsFukNbzuMojSTe+cqB74wf3faXFeHjKniAWz0Q381
         0Jx6M/97fEFjKmT7RvdyQKWIJ8S732zFrOG/s=
Date: Wed, 19 Aug 2009 03:23:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 08/12] tracing: add kprobe-based event tracer
Message-ID: <20090819012306.GJ5231@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203510.31965.29123.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813203510.31965.29123.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:35:11PM -0400, Masami Hiramatsu wrote:
> Add kprobes-based event tracer on ftrace.
> 
> This tracer is similar to the events tracer which is based on Tracepoint
> infrastructure. Instead of Tracepoint, this tracer is based on kprobes
> (kprobe and kretprobe). It probes anywhere where kprobes can probe(this
>  means, all functions body except for __kprobes functions).
> 
> Similar to the events tracer, this tracer doesn't need to be activated via
> current_tracer, instead of that, just set probe points via
> /sys/kernel/debug/tracing/kprobe_events. And you can set filters on each
> probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
> 
> This tracer supports following probe arguments for each probe.
> 
>   %REG  : Fetch register REG
>   sN    : Fetch Nth entry of stack (N >= 0)
>   sa    : Fetch stack address.
>   @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
>   @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
>   aN    : Fetch function argument. (N >= 0)
>   rv    : Fetch return value.
>   ra    : Fetch return address.
>   +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.
> 
> See Documentation/trace/kprobetrace.txt for details.
> 
> Changes from v13:
>  - Support 'sa' for stack address.
>  - Use call->data instead of container_of() macro.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> ---
> 
>  Documentation/trace/kprobetrace.txt |  139 ++++


I'll probably split this commit to have the first version of the
documentation as a separate patch in order to lighten this.

Frederic.

