Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXK3AAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXK3AAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXK3AAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:00:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbXK3AAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:00:39 -0500
Date: Thu, 29 Nov 2007 15:59:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, ak@suse.de, suresh.b.siddha@intel.com,
       markus.t.metzger@intel.com, Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Message-Id: <20071129155940.7df70ac2.akpm@linux-foundation.org>
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 08:14:10 -0000
"Metzger, Markus T" <markus.t.metzger@intel.com> wrote:

> Support for Intel's last branch recording to ptrace. This gives
> debuggers
> access to this hardware feature and allows them to show an execution
> trace
> of the debugged application.
> 
> Last branch recording (see section 18.5 in the Intel 64 and IA-32
> Architectures Software Developer's Manual) allows taking an execution
> trace of the running application without instrumentation. When a branch
> is executed, the hardware logs the source and destination address in a
> cyclic buffer given to it by the OS.
> 
> This can be a great debugging aid. It shows you how exactly you got
> where you currently are without requiring you to do lots of single
> stepping and rerunning.
> 
> This patch manages the various buffers, configures the trace
> hardware, disentangles the trace, and provides a user interface via
> ptrace. On the high-level design:
> - there is one optional trace buffer per thread_struct
> - upon a context switch, the trace hardware is reconfigured to either
>   disable tracing or to use the appropriate buffer for the new task.
>   - tracing induces ~20% overhead as branch records are sent out on
>     the bus. 
>   - the hardware collects trace per processor. To disentangle the
>     traces for different tasks, we use separate buffers and reconfigure
>     the trace hardware.
> - the low-level data layout is configured at cpu initialization time
>   - different processors use different branch record formats
> 
> 
> patch 1/2 contains the kernel changes
> patch 2/2 contains changes to the ptrace man pages
> 
> 

Is there any userspace code avaialble which people can use to play with
this?

How do you envisage it being used in the long term?  Do you expect any of
the standard performance tuning tools will be tweaked to understand this
feature and if so which ones?

I'm generally wondering "how will developers be using this in a year or
two's time?"

Please cc Michael Kerrisk <mtk-manpages@gmx.net> on future versions of
these patches.

The patches were horridly wordwrapped.

Is there any likelihood that any other CPUs do now or will in the future
support any similar feature to this?  If so, is an implementation which is
100% contained to arch/x86 appropriate?  

