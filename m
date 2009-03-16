Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZCQAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZCQAC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZCQACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:02:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbZCQACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:02:07 -0400
To: "Jan Beulich" <jbeulich@novell.com>
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
From: Andi Kleen <andi@firstfloor.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
	<1236931920-6861-11-git-send-email-jeremy@goop.org>
	<49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org>
	<49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org>
	<20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org>
	<20090315170945.08344b86@infradead.org>
	<49BE6D50.76E4.0078.0@novell.com>
Date: Tue, 17 Mar 2009 00:59:20 +0100
In-Reply-To: <49BE6D50.76E4.0078.0@novell.com> (Jan Beulich's message of "Mon, 16 Mar 2009 14:16:32 +0000")
Message-ID: <87fxhd2f53.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

>>>> Arjan van de Ven <arjan@infradead.org> 16.03.09 01:09 >>>
>>Well.. pretty much all new instructions need Xen modifications due to
>>the need to be emulate to deal with traps/vmexits/etc right? 
>>So I don't quite see many cpuid bits that would NOT involve some Xen
>>modification or another ;)
>
> No, new (user-mode accessible) instructions represent precisely the kind
> of extension that do not require hypervisor (or OS) awareness (see SSE2
> etc, AES, FMA). New registers otoh are examples of where awareness is
> needed (SSE, AVX), as would be new privileged instructions.

Whey would another hypothetical FP register extension need Xen support
once it gets proper XSAVE support? I can't think of a reason why
(assuming XSAVE support) it would need to know of a new kind of
FP register or similar. They very likely won't appear in any 
instructions that need mmio. Or are you worried about the real
mode emulator?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
