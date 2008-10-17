Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYJQH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYJQH7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYJQH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:59:05 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:43329 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYJQH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:59:03 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [RFC patch 00/15] Tracer Timestamping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20081016232729.699004293@polymtl.ca>
References: <20081016232729.699004293@polymtl.ca>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 09:59:13 +0200
Message-Id: <1224230353.28131.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 19:27 -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> Starting with the bottom of my LTTng patchset
> (git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git)
> I post as RFC the timestamping infrastructure I have been using for a while in
> the tracer. It integrates get_cycles() standardization following David Miller's
> comments I did more recently.
> 
> It also deals with 32 -> 64 bits timestamp counter extension with a RCU-style
> algorithm, which is especially useful on MIPS and SuperH architectures.

Have you looked at the existing 32->63 extention code in
include/linux/cnt32_to_63.h and considered unifying it?

> There is also a TSC synchronization test within this patchset to detect
> unsynchronized TSCs. 

We already have such code, no? Does this code replace that one or just
add a second test?

> See comments in this specific patch to figure out the
> difference between the current x86 tsc_sync.c and the one I propose in this
> patch.

Right so you don't unify, that's a missed opportunity, no?

> It also provides an architecture-agnostic fallback in case there is no
> timestamp counter available : basically, it's
> (jiffies << 13) | atomically_incremented_counter (if there are more than 8192
> events per jiffy, time will still be monotonic, but will increment faster than
> the actual system frequency).
> 
> Comments are welcome. Note that this is only the beginning of the patchset. I
> plan to submit the event ID allocation/portable event typing aimed at exporting
> the data to userspace and buffering mechanism as soon as I integrate a core
> version of the LTTV userspace tools to the kernel build tree. Other than that, I
> currently have a tracer which fulfills most of the requirements expressed
> earlier. I just fear that if I release only the kernel part without foolproof
> binary-to-ascii trace decoder within the kernel, people might be a bit reluctant
> to fetch a separate userspace package.

It might be good to drop all the ltt naming and pick more generic names,
esp. as ftrace could use a lot of this infrastructure as well.

