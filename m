Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYAYPay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYAYPay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYAYPao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:30:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYAYPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:30:43 -0500
Date: Fri, 25 Jan 2008 16:30:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
Message-ID: <20080125153032.GE11846@elte.hu>
References: <4797D64D.1060105@goop.org> <1201133916.16972.124.camel@brick> <4797DBA0.5020909@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4797DBA0.5020909@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When changing a kernel page from RO->RW, it's OK to leave stale TLB 
> entries around, since doing a global flush is expensive and they pose 
> no security problem.  They can, however, generate a spurious fault, 
> which we should catch and simply return from (which will have the 
> side-effect of reloading the TLB to the current PTE).
>
> This can occur when running under Xen, because it frequently changes 
> kernel pages from RW->RO->RW to implement Xen's pagetable semantics. 
> It could also occur when using CONFIG_DEBUG_PAGEALLOC, since it avoids 
> doing a global TLB flush after changing page permissions.

thanks, applied.

it would be nice to expose this ability of the architecture to the core 
Linux kernel mprotect code as well, and let it skip on a TLB flush when 
doing a RO->RW transition. It could speed up valgrind and the other 
mprotect() users i guess? [and UML too perhaps]

	Ingo
