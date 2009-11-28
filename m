Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZK1KFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZK1KFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 05:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZK1KFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 05:05:23 -0500
Received: from ozlabs.org ([203.10.76.45]:57709 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZK1KFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 05:05:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
Date: Sat, 28 Nov 2009 20:35:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Ian Molton <ian.molton@collabora.co.uk>, linux-kernel@vger.kernel.org
References: <1259177252.2858.17.camel@calx> <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk> <1259197403.2858.88.camel@calx>
In-Reply-To: <1259197403.2858.88.camel@calx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911282035.26847.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 11:33:23 am Matt Mackall wrote:
> On Thu, 2009-11-26 at 00:25 +0000, Ian Molton wrote:
> >  #define PFX			RNG_MODULE_NAME ": "
> >  #define RNG_MISCDEV_MINOR	183 /* official */
> > +#define RNG_BUFFSIZE		64
> 
> How about just:
> 
> static u8 rng_buffer[RNG_BUFFSIZE] __cacheline_aligned;
> 
> And lose all the kmalloc and kfree code? The memory use will be smaller,
> even when the buffer isn't needed.

And might as well just #defube RNG_BUFFSIZE SMP_CACHE_BYTES (or use
SMP_CACHE_BYTES here and sizeof() elsewhere).

> > +		if (!data_avail) {
> > +			bytes_read = rng_get_data(current_rng, rng_buffer,
> > +				RNG_BUFFSIZE, !(filp->f_flags & O_NONBLOCK));
> 
> No need to pass rng_buffer to the helper as there's only one with global
> scope.

Naah, I like the separation; it matches the rest of the kernel and means we
can get funky with buffer management in 10 years time when we rewrite this
again.

Thanks,
Rusty.
