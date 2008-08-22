Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYHVGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYHVGZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYHVGZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51710 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYHVGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:25:14 -0400
Message-ID: <48AE5BB8.5080701@zytor.com>
Date: Thu, 21 Aug 2008 23:24:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@kernel.org>, Dave Jones <davej@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <20080822022841.GG23334@one.firstfloor.org>
In-Reply-To: <20080822022841.GG23334@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> You may want to see if this patch fixes the problem; it does *NOT* have 
>> the correct error behaviour (some of the intervening layers don't 
>> propagate errors), but it should make the fault go away.
> 
> The alternative would be to just take out those msr_on_cpu() 
> interfaces again. Right now they are useless in the kernel,
> but still cause problems.
> 
> They were only added for OpenVZ's vCPUs which they back then
> promised me would hit mainline soon. But that was some time
> ago and there wasn't much progress on this.
> 
> -Andi

We still need the equivalent functionality, though.  The midlayer 
(msr_on_cpu) may be pointless, but that doesn't change the fact that 
putting this functionality in the lower layer (smp_call_function_single) 
makes more sense.

	-hpa
