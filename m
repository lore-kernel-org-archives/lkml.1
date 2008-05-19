Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYESJpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYESJpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYESJpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:45:40 -0400
Received: from gw.goop.org ([64.81.55.164]:35498 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYESJpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:45:40 -0400
Message-ID: <48314C33.7010604@goop.org>
Date: Mon, 19 May 2008 10:45:23 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
References: <482C8595.5030509@garzik.org> <200805191905.11452.rusty@rustcorp.com.au> <48314419.4080606@goop.org> <200805191928.13043.rusty@rustcorp.com.au>
In-Reply-To: <200805191928.13043.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Unfortunately not.  Hardware randomness devices export /dev/hwrng, and it's up 
> to userspace to feed that into /dev/random (or not).  That's usually done by 
> rngd, which at least on my system, assumes 1 bit of entropy per bit of data 
> from /dev/hwrng by default.
>
> I was a little surprised that this decision was exported to userspace, but if 
> you're not prepared to unconditionally trust hw rngs, it makes sense to palm 
> it off.

Yeah, that's a bit of a pity.  Hardware rngs can often generate really 
crappy randomness, which needs tons of processing to remove noise like 
50/60hz hum, etc.

>   We could write a boutique device for virtualization which *did* feed 
> directly, but that would be a little gauche.
>   

Well, yes, we can certainly do any amount of processing we like to the 
stuff provided to guests, so that the 1:1 bits/entropy ratio is as true 
as we can make it.

    J
