Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYEQG21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYEQG21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 02:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYEQG2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 02:28:17 -0400
Received: from ozlabs.org ([203.10.76.45]:37317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYEQG2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 02:28:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Date: Sat, 17 May 2008 16:28:03 +1000
User-Agent: KMail/1.9.9
Cc: Johannes Berg <johannes@sipsolutions.net>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Matt Mackall <mpm@selenic.com>
References: <482C8595.5030509@garzik.org> <200805171446.39814.rusty@rustcorp.com.au> <482E6417.8040602@zytor.com>
In-Reply-To: <482E6417.8040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805171628.03801.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2008 14:50:31 H. Peter Anvin wrote:
> Rusty Russell wrote:
> > On Friday 16 May 2008 20:49:41 Johannes Berg wrote:
> >>> +
> >>> +/* Our random number generator device reads from /dev/urandom into the
> >>> Guest's + * input buffers.  The usual case is that the Guest doesn't
> >>> want random numbers + * and so has no buffers although /dev/urandom is
> >>> still readable, whereas + * console is the reverse.
> >>
> >> Is it really a good idea to use the hosts /dev/urandom to fill the
> >> guests /dev/random?
> >
> > Technically it's up to rngd in the guest to decide whether to feed
> > entropy or not (ie. /dev/urandom or /dev/random).
>
> Uhm, no.  It's not.  Unless the host provides actual entropy
> information, you have a security hole.

Huh?  We just can't assume it adds entropy.  AFAICT rngd -H0 is what we want 
here.

> > If we use /dev/random in the host, we risk a DoS.  But since /dev/random
> > is 0666 on my system, perhaps noone actually cares?
>
> There is no point in feeding the host /dev/urandom to the guest (except 
> for seeding, which can be handled through other means); it will do its 
> own mixing anyway.

Seeding is good, but unlikely to be done properly for first boot of some 
standard virtualized container.  In practice, feeding /dev/urandom from the 
host will make /dev/urandom harder to predict in the guest.

> The reason to provide anything at all from the host 
> is to give it "golden" entropy bits.

But you did not address the DoS question: can we ignore it?  Or are we trading 
off a DoS in the host against a potential security weakness in the guest?

If so, how do we resolve it?

Thanks,
Rusty.
