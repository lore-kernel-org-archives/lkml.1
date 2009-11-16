Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZKPNsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZKPNsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZKPNsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:48:45 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:38168 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZKPNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:48:45 -0500
Date: Mon, 16 Nov 2009 14:48:31 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: Re: [PATCH v8 00/16] ftrace for MIPS
Message-ID: <20091116134831.GA10189@linux-mips.org>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 02:30:31PM +0800, Wu Zhangjin wrote:

Time to talk about how to get the whole thing merged.

I'm reasonably happy with the arch part of the patchset.  There are two
remaining issues in the arch part - cache flushing will not work as is on
a SMP system and the whole code patching is going to fail if the kernel
text is replicated with CONFIG_REPLICATE_KTEXT which is an IP27-only option.

I suggest we should go ahready and just disallow dynamic ftrace on on
these problematic configurations for now and deal with them later, so
something like

	select HAVE_DYNAMIC_FTRACE if !SMP && !REPLICATE_KTEXT

This leaves the non-arch bits to merge; patches which touch code outside
of arch/mips are:

    [PATCH v8 01/16] tracing: convert trace_clock_local() as weak function
    [PATCH v8 06/16] tracing: add an endian argument to
    [PATCH v8 07/16] tracing: add dynamic function tracer support for MIPS
    [PATCH v8 09/16] tracing: define a new __time_notrace annotation flag
    [PATCH v8 10/16] tracing: not trace the timecounter_read* in

  Ralf
