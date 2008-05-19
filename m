Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYESJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYESJ23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYESJ2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:28:19 -0400
Received: from ozlabs.org ([203.10.76.45]:34310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbYESJ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:28:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Date: Mon, 19 May 2008 19:28:12 +1000
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <482C8595.5030509@garzik.org> <200805191905.11452.rusty@rustcorp.com.au> <48314419.4080606@goop.org>
In-Reply-To: <48314419.4080606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191928.13043.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 19:10:49 Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > On Saturday 17 May 2008 17:47:01 Jeremy Fitzhardinge wrote:
> >> But the host->guest protocol should include the number of bits estimated
> >> entropy along with the bits themselves.
> >
> > If we go down that path, we have to come up with a way of feeding that
> > information to guest userspace.  Patches welcome.  If we meanwhile assume
> > entropy == #bits, it fits the current /dev/hwrng model, and we can add an
> > entropy count later if we want to change that.
>
> Really?  Wouldn't guest userspace just use /dev/random as usual, which I
> think does have an ioctl to give that kind of information?  And the
> interfaces do allow things injecting entropy into the kernel pool to
> provide entropy estimates along with the actual bits themselves.

Unfortunately not.  Hardware randomness devices export /dev/hwrng, and it's up 
to userspace to feed that into /dev/random (or not).  That's usually done by 
rngd, which at least on my system, assumes 1 bit of entropy per bit of data 
from /dev/hwrng by default.

I was a little surprised that this decision was exported to userspace, but if 
you're not prepared to unconditionally trust hw rngs, it makes sense to palm 
it off.  We could write a boutique device for virtualization which *did* feed 
directly, but that would be a little gauche.

Cheers,
Rusty.
