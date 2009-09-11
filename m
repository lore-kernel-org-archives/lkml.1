Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZIKPgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZIKPgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZIKPgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:36:15 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45007 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZIKPgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r/1xzpe7+mDjg65WL0FWSHZ4ibTX3FzYRzdQKNl27phwUMBlT5mlFJunBXY+gdy0Vc
         84d1e6hfMUAagpWM2vgkbpbNDz1107OoFb/S8nQfXaB68+3JcdYzu/ACWh/gD2zmSXKd
         oqJJCqlbbzgdpOAaU5prFAQ0IxUSZtvirh1mU=
Date: Fri, 11 Sep 2009 17:36:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based
	event tracer update and perf support
Message-ID: <20090911153609.GA6069@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:52:58PM -0400, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> This series fixes bugs and upgrades kprobe-based event tracer
> as a dynamic event tracer on ftrace/perf tools. This also enhances
> tracer output format to show each argument name and event name on
> each entry.
> 
> With this series, users can add trace events dynamically on ftrace
> and use those events with perf tools as below.
> 
> (Step.1) Define new events under new group
> 
> $ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
>  > /debug/tracing/kprobes_events
> $ echo r:mygroup/myretprobe do_sys_open rv >> /debug/tracing/kprobes_events
> $ cat /debug/tracing/kprobes_events
> p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
> r:myretprobe do_sys_open+0 rv=rv



I've tested the above example and it works very well,
so I've applied this set, and the previous pending patches
in:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	tracing/kprobes

Thanks.

