Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYHWGry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYHWGry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 02:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYHWGrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 02:47:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYHWGro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 02:47:44 -0400
Message-ID: <48AFB1C2.5020806@zytor.com>
Date: Fri, 22 Aug 2008 23:44:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@kernel.org>,
       Dave Jones <davej@redhat.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <20080822022841.GG23334@one.firstfloor.org> <48AE5BB8.5080701@zytor.com> <20080822093518.GK23334@one.firstfloor.org> <48AEEC4F.3060003@zytor.com> <48AFB14F.7090407@goop.org>
In-Reply-To: <48AFB14F.7090407@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Well, smp_call_function_single already does all necessary locking; it
>> makes more sense for it to check that what it's about to call still
>> exists while inside the lock, instead of requiring the higher layers
>> to guarantee that cannot happen on it.  This is simply a matter of the
>> cost of checking at this point being quite low. 
> 
> It does, already doesn't it?  Hm, smp_call_function_mask() ands the
> provided mask with the online mask, but it doesn't look like
> smp_call_function_single() does the equivalent.

It doesn't, and that's how this bug was introduced.  It's a trivial add 
(see test patch already posted) and should hardly matter in terms of 
execution time.

I'll write up a clean patch with all the error propagation tomorrow or 
Sunday.

	-hpa
