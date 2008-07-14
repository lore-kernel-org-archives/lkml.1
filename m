Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYGNAI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYGNAI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYGNAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:08:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYGNAIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:08:21 -0400
Message-ID: <487A9804.8090307@zytor.com>
Date: Sun, 13 Jul 2008 17:04:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <20080710071640.5035cd70@infradead.org> <874p6t25n5.fsf@basil.nowhere.org> <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com> <487A4DFC.5090701@firstfloor.org> <20080713203250.GA6925@elte.hu> <487A6AD0.5000506@firstfloor.org>
In-Reply-To: <487A6AD0.5000506@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> First I was only commenting on one specific patch, nothing more.
> 
> My point is full rounding to 4K on all corners is wasteful because the
> CPUs have to handle that case anyways and every split costs precious
> TLB entries in direct mapping accesses.
>

Well, the CPU *does* handle them... by splitting the larger pages into 
smaller pages.  They still end up in the small-page TLB, so there is no 
real difference if done in the CPU or in software.

> And I might be old fashioned, but I still think minimizing TLB misses
> in the kernel is still quite important since the TLBs of modern x86
> CPUs are still comparatively small.
> 
> btw that is why I was  also quite disappointed that the new cpa eliminated
> reassembly. It means that on a long uptime system even with moderate
> traffic of CPA page allocation/free eventually the completely direct mapping
> will be all 4K. And there will be TLB miss galore on each system call
> when user space is TLB intensive.
> 
> Ok in that light Yinghai's patch is perhaps not so bad after longer
> uptime in that scenario. Still performance directly after boot up is
> also something that shouldn't be ignored and I'm still hopefully that
> reassembly will be readded at some point anyways.

Memory state transitions are (fortunately) relatively rare and 
long-lived, but of course having reassembly is a nice thing to have in 
the long run.  Such reassembly also would rather naturally handle any 
small-page effects of boundary cases.

	-hpa
