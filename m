Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZETVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZETVBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZETVBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:01:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZETVBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:01:40 -0400
Message-ID: <4A146E78.6000600@zytor.com>
Date: Wed, 20 May 2009 13:56:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Q: put_user_try & co (Was: [PATCH 1/5] Split wait_noreap_copyout())
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>	<1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>	<20090511120418.GA3859@infradead.org>	<20090511121708.GD13954@elte.hu>	<20090520190312.GA32333@redhat.com> <20090520201127.48B54FC38D@magilla.sf.frob.com>
In-Reply-To: <20090520201127.48B54FC38D@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> 
> You mean &&__efault_label here (it's a funny syntax, but that's how it is).
> &&label is a GCC extension that I'm not sure the kernel has used before.
> 
> I think it can be touchy to have an asm jump into compiled code that way.
> e.g., perhaps the compiler produced:
> 
> 	mov reg, 40(sp)
> 	mov $123, reg
> 	#APP
> 	... inside of your asm ...
> 	#NO_APP
> 	mov 40(sp), reg
> 
> or some such thing.  If you jump away from inside the asm, you won't ever
> do "mov 40(sp), reg".  But the compiler might think that reg has its
> original value at the __efault_label: code location.
> 
> Perhaps more important than any particular compiler-confusion scenario we
> can come up with is simply that this would be an obscure corner of code
> generation in the compiler that the kernel has not evoked before.  There
> might be bugs or oddities in various compilers of various vintages, that
> we don't know about because they never came up before.
> 

Yes, it seems like a bad idea to me.

	-hpa
