Return-Path: <linux-kernel-owner+w=401wt.eu-S1765751AbXJSGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765751AbXJSGXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXJSGXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:23:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4041 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbXJSGXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:23:11 -0400
Date: Fri, 19 Oct 2007 13:53:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-ID: <20071019055333.GA10748@gondor.apana.org.au>
References: <E1IiWnJ-0000ne-00@gondolin.me.apana.org.au> <1192745137.7367.40.camel@pasglop> <alpine.LFD.0.999.0710181549330.26902@woody.linux-foundation.org> <1192749449.7367.51.camel@pasglop> <alpine.LFD.0.999.0710181627091.26902@woody.linux-foundation.org> <20071019023219.GB8453@gondor.apana.org.au> <alpine.LFD.0.999.0710181941020.26902@woody.linux-foundation.org> <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org> <1192767073.7367.84.camel@pasglop> <1192768014.7367.96.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192768014.7367.96.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 02:26:54PM +1000, Benjamin Herrenschmidt wrote:
>
> I think a simple smp_mb(); here after foo = 1; is enough, which means
> basically just having an smp_mp(); inside napi_synchronize(), before
> the test_bit(). Or do I miss something ?

Yes I think you're right.  In this case we do have barriers
everywhere else so this should work.

Although if you want napi_synchronize to have the property that
when it returns all NAPI processing effects are visible then
you'd need another smp_mb() after the loop.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
