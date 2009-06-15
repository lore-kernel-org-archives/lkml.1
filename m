Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbZFOScD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbZFOScD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765732AbZFOSbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:31:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759239AbZFOSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:31:51 -0400
Date: Mon, 15 Jun 2009 11:30:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615180527.GB4201@Krystal>
Message-ID: <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Mathieu Desnoyers wrote:
> 
> Hrm, would it be possible to save the c2 register upon nmi handler entry
> and restore it before iret instead ?

Yes, that would work as well, and be less subtle.

It still does have the same worries about CPU's not being all that happy 
about writing to %cr2 (we do it when restoring CPU state at resume time, 
but nobody has ever _cared_ before, so I don't know if it matters).

		Linus
