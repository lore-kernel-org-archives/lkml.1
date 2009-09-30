Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZI3Xyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZI3Xyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZI3Xyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:54:41 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43024 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754990AbZI3Xyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:54:40 -0400
Date: Wed, 30 Sep 2009 19:49:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Chubb <peterc@gelato.unsw.edu.au>
cc: "Luck, Tony" <tony.luck@intel.com>, Tejun Heo <teheo@suse.de>,
       Nick Piggin <npiggin@suse.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET percpu#for-next] percpu: convert ia64 to dynamic percpu
 and drop the old one, take#2
In-Reply-To: <87hbukxcau.wl%peter@chubb.wattle.id.au>
Message-ID: <alpine.DEB.1.10.0909301946510.11850@gentwo.org>
References: <1253682382-24740-1-git-send-email-tj@kernel.org> <4AC153EA.2050007@suse.de> <57C9024A16AD2D4C97DC78E552063EA3E2F03E58@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0909301644460.9271@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E2F03FDC@orsmsx505.amr.corp.intel.com>
 <87hbukxcau.wl%peter@chubb.wattle.id.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Peter Chubb wrote:

> r3, r4 and r5 are currently unused by the kernel, and unused
> by GCC and ICC.   Only hand-written assembler and weird compilers use
> those registers(and my virtual-machine monitor :-().  If you wanted to
> experiment, that'd be a starting place.
>
> I'm not sure of the advantage though -- TLB mapping is relatively
> cheap, and we're no longer hard-wiring the translation register.

Dynamic and static per cpu variables could use relative access to that
register. This would reduce code size, avoid the use of a TLB entry.

> You';d have to do somne careful benchmarking on a wide variety of
> workloads and machines to get a definitive answer.

I have some patches here that make heavy use of dynamic percpu allocations
in the allocators to optimize the alloc / free paths.

