Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYH2QPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYH2QPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYH2QPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:15:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbYH2QPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:15:21 -0400
Date: Fri, 29 Aug 2008 09:14:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jes Sorensen <jes@sgi.com>
cc: David Miller <davem@davemloft.net>, travis@sgi.com, mingo@elte.hu,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <48B7EEA2.7090300@sgi.com>
Message-ID: <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
References: <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net> <48B4542A.1050004@sgi.com> <20080826.134535.193703558.davem@davemloft.net> <48B7EEA2.7090300@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Jes Sorensen wrote:
> 
> I have only tested this on ia64, but it boots, so it's obviously
> perfect<tm> :-)

Well, it probably boots because it doesn't really seem to _change_ much of 
anything.

Things like this:

	-static inline void arch_send_call_function_ipi(cpumask_t mask)
	+static inline void arch_send_call_function_ipi(cpumask_t *mask)
	 {
	-       smp_ops.send_call_func_ipi(mask);
	+       smp_ops.send_call_func_ipi(*mask);
	 }

will still do that stack allocation at the time of the call. You'd have to 
pass the thing all the way down as a pointer..

			Linus


