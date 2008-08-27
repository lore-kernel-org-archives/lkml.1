Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYH0V13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYH0V13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYH0V1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:27:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbYH0V1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:27:16 -0400
Date: Wed, 27 Aug 2008 14:26:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Vrabel <david.vrabel@csr.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Roland Dreier <rdreier@cisco.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [patch] Add helper macros for little-endian bitfields
In-Reply-To: <48B570D6.7070301@csr.com>
Message-ID: <alpine.LFD.1.10.0808271424030.3363@nehalem.linux-foundation.org>
References: <48AD6AF0.3050504@csr.com> <48AD6B93.7020702@csr.com> <adaprnxnac8.fsf@cisco.com> <20080825014311.GS28946@ZenIV.linux.org.uk> <48B570D6.7070301@csr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, David Vrabel wrote:
> 
> But why is this worthy of a crispy flaming?  I've not seen anything
> definite beyond a somewhat vague 'some compilers don't optimize
> bitfields very well'.

Actually, it's not that compilers often optimize bitfields really badly.

It's also that bitfields are a total f*cking disaster when it comes to 
endianness. As you found out.

Bitfields are fine if you don't actually care about the underlying format, 
and want gcc to just randomly assign bits, and want things to be 
convenient in that situation.

But _if_ you care about the underlying format, then inevitably the 
bitfield costs will be much higher than just using bit operations on a
"u32" or similar. Your helper macros are horrible compared to just making 
the bits work out right to begin with, and using the standard byte order 
things.

		Linus
