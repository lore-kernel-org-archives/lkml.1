Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYCUNTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYCUNTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYCUNSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:18:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:13600 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbYCUNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:18:45 -0400
Message-ID: <7c86c4470803210618j46d0dceay16757a90b9c7c48b@mail.gmail.com>
Date: Fri, 21 Mar 2008 14:18:44 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] x86, ptrace: support pebs in ds.c and disable ptrace and ds support
Cc: "Markus Metzger" <markus.t.metzger@intel.com>, ak@suse.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       roland@redhat.com, akpm@linux-foundation.org, mtk.manpages@gmail.com
In-Reply-To: <20080321125338.GB27245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080312125318.A15510@sedona.ch.intel.com>
	 <20080321125338.GB27245@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The PEBS support does not extend all the way to ptrace.
It does not make sense anyway.

I am fine with not using ptrace to expose BTS. But this needs
to be exposed to user level somehow.  It is useful for many debugging
tools.


On Fri, Mar 21, 2008 at 1:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Markus Metzger <markus.t.metzger@intel.com> wrote:
>
>  > Polish the ds.h interface and add support for PEBS.
>  >
>  > Guard DS support and the ptrace interface to BTS by CONFIG macros;
>  > disabled per default.
>  >
>  > Ds.c is meant to be the resource allocator for per-thread and per-cpu
>  > BTS and PEBS recording.
>  > It is used by ptrace to provide execution tracing of debugged tasks.
>  > It will be used by utrace for the same purpose.
>  > It will be used by profilers (e.g. perfmon2).
>  > It may be used by kernel debuggers to provide a kernel execution trace.
>
>  we could apply this if Roland Acks it - but i guess a precondition for
>  that is to not include more ptrace extensions and to also start working
>  on utrace support for it. Ptrace is something we want to reduce usage
>  of, not extend.
>
>         Ingo
>
