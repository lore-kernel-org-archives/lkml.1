Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYKGO6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYKGO6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbYKGO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:58:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:23309 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYKGO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=GYyy7LVXoVhr6oY7wTUjRi5E08uJBb8wkpDDNQf1AXQlBXlIG5MhEkjC7EyMwA8/sn
         zk3r7CCqSSABL536BGGwURgdh8zKNkyXQeM3PCy6b8NgV4qLeBEy32OYpuQKY438fU4q
         RjKeI7oNyN7t482t2u6Oj6Mwq/+YKCZq2+ivo=
Date: Fri, 7 Nov 2008 09:56:36 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 04/18] get_cycles() : powerpc64 HAVE_GET_CYCLES
Message-ID: <20081107145636.GA5021@yoda.jdub.homelinux.org>
References: <20081107052336.652868737@polymtl.ca> <20081107053349.215096700@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107053349.215096700@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 12:23:40AM -0500, Mathieu Desnoyers wrote:
>This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
>get_cycles_rate() are implemented.
>
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>CC: benh@kernel.crashing.org
>CC: paulus@samba.org
>CC: David Miller <davem@davemloft.net>
>CC: Linus Torvalds <torvalds@linux-foundation.org>
>CC: Andrew Morton <akpm@linux-foundation.org>
>CC: Ingo Molnar <mingo@redhat.com>
>CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
>CC: Thomas Gleixner <tglx@linutronix.de>
>CC: Steven Rostedt <rostedt@goodmis.org>
>CC: linux-arch@vger.kernel.org
>---
> arch/powerpc/Kconfig             |    1 +
> arch/powerpc/include/asm/timex.h |   11 +++++++++++
> 2 files changed, 12 insertions(+)
>
>Index: linux.trees.git/arch/powerpc/Kconfig
>===================================================================
>--- linux.trees.git.orig/arch/powerpc/Kconfig	2008-11-07 00:09:44.000000000 -0500
>+++ linux.trees.git/arch/powerpc/Kconfig	2008-11-07 00:09:46.000000000 -0500
>@@ -121,6 +121,7 @@ config PPC
> 	select HAVE_DMA_ATTRS if PPC64
> 	select USE_GENERIC_SMP_HELPERS if SMP
> 	select HAVE_OPROFILE
>+	select HAVE_GET_CYCLES if PPC64

So maybe it's just me because it's Friday and I'm on vacation, but I don't
see anything overly specific to ppc64 here.  In fact, you use get_cycles_rate
for all of powerpc in a later patch in the series.

Is there something special about HAVE_GET_CYCLES that I'm missing that would
make it only apply to ppc64 and not ppc32?

josh
