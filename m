Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYEQErG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYEQErG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYEQEqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:46:54 -0400
Received: from ozlabs.org ([203.10.76.45]:37408 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYEQEqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:46:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Date: Sat, 17 May 2008 14:46:39 +1000
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, Jeff Garzik <jeff@garzik.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Anvin" <hpa@zytor.com>,
       Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>
References: <482C8595.5030509@garzik.org> <200805161539.59739.rusty@rustcorp.com.au> <1210934981.6381.1.camel@johannes.berg>
In-Reply-To: <1210934981.6381.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805171446.39814.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 20:49:41 Johannes Berg wrote:
> > +
> > +/* Our random number generator device reads from /dev/urandom into the Guest's
> > + * input buffers.  The usual case is that the Guest doesn't want random numbers
> > + * and so has no buffers although /dev/urandom is still readable, whereas
> > + * console is the reverse. 
>
> Is it really a good idea to use the hosts /dev/urandom to fill the
> guests /dev/random?

Technically it's up to rngd in the guest to decide whether to feed entropy
or not (ie. /dev/urandom or /dev/random).

If we use /dev/random in the host, we risk a DoS.  But since /dev/random
is 0666 on my system, perhaps noone actually cares?

Cheers,
Rusty.
