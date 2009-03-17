Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZCQBmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZCQBmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZCQBmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:42:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZCQBmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:42:22 -0400
Message-ID: <49BEFDFB.8070900@zytor.com>
Date: Mon, 16 Mar 2009 18:33:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org>	<49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org>	<49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org>	<20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org>	<20090315170945.08344b86@infradead.org>	<49BE6D50.76E4.0078.0@novell.com> <87fxhd2f53.fsf@basil.nowhere.org>
In-Reply-To: <87fxhd2f53.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Jan Beulich" <jbeulich@novell.com> writes:
> 
>>>>> Arjan van de Ven <arjan@infradead.org> 16.03.09 01:09 >>>
>>> Well.. pretty much all new instructions need Xen modifications due to
>>> the need to be emulate to deal with traps/vmexits/etc right? 
>>> So I don't quite see many cpuid bits that would NOT involve some Xen
>>> modification or another ;)
>> No, new (user-mode accessible) instructions represent precisely the kind
>> of extension that do not require hypervisor (or OS) awareness (see SSE2
>> etc, AES, FMA). New registers otoh are examples of where awareness is
>> needed (SSE, AVX), as would be new privileged instructions.
> 
> Whey would another hypothetical FP register extension need Xen support
> once it gets proper XSAVE support? I can't think of a reason why
> (assuming XSAVE support) it would need to know of a new kind of
> FP register or similar. They very likely won't appear in any 
> instructions that need mmio. Or are you worried about the real
> mode emulator?
> 

The point is YOU DON'T KNOW.  In particular, there might be new traps,
there might be new state, there might be new MSRs, there might be new
control bits... anything.  Therefore, you cannot blindly pass the bit
on, even though XSAVE solves one part of the problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

