Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870Ab0AKOgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0AKOgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267Ab0AKOgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:36:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0AKOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:36:23 -0500
Message-ID: <4B4B373B.5010802@redhat.com>
Date: Mon, 11 Jan 2010 09:35:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/7] UBP, XOL and Uprobes
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> Hi, 
> 
> This patchset implements Uprobes which enables you to dynamically
> break into any routine in a user space application and collect
> information non-disruptively.  Uprobes is based on utrace and uses
> x86 instruction decoder.
> 
> When a uprobe is registered, Uprobes makes a copy of the probed
> instruction, stops the probed application, replaces the first
> byte(s) of the probed instruction with a breakpoint instruction and
> allows the probed application to continue.  (Uprobes uses the same
> copy-on-write mechanism so that the breakpoint affects only that
> process.)
> 
> When a CPU hits the breakpoint instruction, Uprobes intercepts the
> SIGTRAP and finds the associated uprobe.  It then executes the
> associated handler.  Uprobes single-steps its copy of the probed
> instruction and resumes execution of the probed process at the
> instruction following the probepoint. Instruction copies to be
> single-stepped are stored in a per-process "single-step out of line
> (XOL) area,"
> 
> Uprobes can be used to take advantage of static markers available
> in user space applications.
> 
> Advantages of uprobes over conventional debugging include:
> 1. Non-disruptive.
> 2. Uses Execution out of line(XOL), 
> 3. Much better handling of multithreaded programs because of XOL.
> 4. No context switch between tracer, tracee.

Hi Srikar and Jim,

Great work! thanks for releasing it.

> 
> Here is the list of TODO Items.
> 
> - Provide a perf interface to uprobes.

I think we also need to integrate ftrace-kprobe/uprobe to support
dynamic trace event. it helps perf probe to support uprobe much
easier. 

> - Return probes.

Hmm, I think we need some symbol information for supporting
return probes in user space. Could you tell me how to work it?
is that requires some user-space helper?

> - Support for Other Architectures.
> - Jump optimization.

I assume that you meant this is "uprobe-booster" to skip
just single stepping after probing, isn't it?


Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

