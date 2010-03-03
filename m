Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab0CCAcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:32:17 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34540 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754887Ab0CCAcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:32:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEY9jUtGGOO+/2dsb2JhbACbC3S+RYR7BIMX
Date: Tue, 2 Mar 2010 19:32:07 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3&10 02/18] kprobes: Introduce generic insn_slot
	framework
Message-ID: <20100303003207.GA7176@Krystal>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6> <20100225133358.6725.82430.stgit@localhost6.localdomain6> <20100225152130.GB12635@Krystal> <4B8C7E23.1000302@redhat.com> <4B8DAAF2.203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B8DAAF2.203@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:30:45 up 76 days,  8:49,  6 users,  load average: 0.47, 0.25,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Masami Hiramatsu wrote:
> > Mathieu Desnoyers wrote:
> >> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> >>> Make insn_slot framework support various size slots.
> >>> Current insn_slot just supports one-size instruction buffer slot. However,
> >>> kprobes jump optimization needs larger size buffers.
> >>
> >> OK, so you end up having one insn slot cache for kprobes and one insn
> >> slot (eventually) for the static jump patching (which needs larger
> >> instruction slots than kprobes). That seems like a good way to ensure
> >> you do not use more memory than necessary.
> >>
> >> We could possibly go even further and automatically use the right insn
> >> slot cache given the size of the instruction entry that must be added (a
> >> bit like the memory allocator which have different pools for each
> >> allocation order).
> > 
> > Sure, that will be simpler interface.
> > 
> >> Possibly that using the terminology of "memory pools" rather than
> >> "cache" could be a better fit too. So what this really becomes is an
> >> instruction slot allocator and garbage collector.
> > 
> > Ah, right. It would be better to rename kprobe_insn_pool() :)
> 
> Hmm, I tried it. And finally, I found that this doesn't help
> to simplify code... Maybe it is better to postpone it until
> another user needs this feature.

I guess it's a tradeoff between the genericity of the API you provide
and the complexity of the code that provides this API. So as you say,
maybe it's better to wait until more users appears before improving the
API.

Thanks,

Mathieu

> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
