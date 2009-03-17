Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbZCQHwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbZCQHwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZCQHwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:52:40 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23950 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZCQHwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:52:39 -0400
Message-Id: <49BF6505.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 17 Mar 2009 07:53:25 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
 <1236931920-6861-11-git-send-email-jeremy@goop.org>
 <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org>
 <49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org>
 <20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org>
 <20090315170945.08344b86@infradead.org>
 <49BE6D50.76E4.0078.0@novell.com><49BE6D50.76E4.0078.0@novell.com> (Jan
 Beulich's message of "Mon, 16 Mar 2009 14:16:32 +0000")
 <87fxhd2f53.fsf@basil.nowhere.org>
In-Reply-To: <87fxhd2f53.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 17.03.09 00:59 >>>
>"Jan Beulich" <jbeulich@novell.com> writes:
>
>>>>> Arjan van de Ven <arjan@infradead.org> 16.03.09 01:09 >>>
>>>Well.. pretty much all new instructions need Xen modifications due to
>>>the need to be emulate to deal with traps/vmexits/etc right? 
>>>So I don't quite see many cpuid bits that would NOT involve some Xen
>>>modification or another ;)
>>
>> No, new (user-mode accessible) instructions represent precisely the kind
>> of extension that do not require hypervisor (or OS) awareness (see SSE2
>> etc, AES, FMA). New registers otoh are examples of where awareness is
>> needed (SSE, AVX), as would be new privileged instructions.
>
>Whey would another hypothetical FP register extension need Xen support
>once it gets proper XSAVE support? I can't think of a reason why
>(assuming XSAVE support) it would need to know of a new kind of
>FP register or similar. They very likely won't appear in any 
>instructions that need mmio. Or are you worried about the real
>mode emulator?

No, properly coded xsave support will (hopefully) make user-visible context
extensions transparent to hypervisor and OS. But I was giving a general
example here, and the change from xmm to ymm registers is one that does
need hypervisor (and OS) changes.

Jan

