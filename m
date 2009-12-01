Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZLADIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZLADIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 22:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZLADIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 22:08:12 -0500
Received: from ozlabs.org ([203.10.76.45]:53736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbZLADIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 22:08:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
Date: Tue, 1 Dec 2009 13:38:15 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Ian Molton <ian.molton@collabora.co.uk>, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>
References: <1259177252.2858.17.camel@calx> <4B139E3D.1020905@collabora.co.uk> <1259606656.29740.48.camel@calx>
In-Reply-To: <1259606656.29740.48.camel@calx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011338.15763.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 05:14:16 am Matt Mackall wrote:
> On Mon, 2009-11-30 at 10:28 +0000, Ian Molton wrote:
> > Rusty Russell wrote:
> > 
> > > And might as well just #defube RNG_BUFFSIZE SMP_CACHE_BYTES (or use
> > > SMP_CACHE_BYTES here and sizeof() elsewhere).
> > 
> > This can lead to a rather small (4 byte) buffer on some systems, however
> > I don't know if in practice a tiny buffer or a big one would be better
> > for performance on those machines. I guess if its a problem someone can
> > patch the code to allocate a minimum of (say) 16 bytes in future...
> 
> Hmmm, I think this was bad advice from Rusty.

Me too.  But really, it's because we're using cacheline alignment
as a proxy for something else, and it's not a good fit.

But we're bikeshedding, so apply or revert.

	/* A buffer which can hold any fundamental type: drivers are fussy. */
	static u8 rng_buffer[SMP_CACHE_BYTES < 8 ? 8 : SMP_CACHE_BYTES]
		__cacheline_aligned;

Either way, both patches: Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
