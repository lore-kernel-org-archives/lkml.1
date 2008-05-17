Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYEQQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYEQQDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYEQQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 12:03:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYEQQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 12:03:15 -0400
Message-ID: <482F0053.2000509@zytor.com>
Date: Sat, 17 May 2008 08:57:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Johannes Berg <johannes@sipsolutions.net>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
References: <482C8595.5030509@garzik.org> <200805171446.39814.rusty@rustcorp.com.au> <482E6417.8040602@zytor.com> <200805171628.03801.rusty@rustcorp.com.au>
In-Reply-To: <200805171628.03801.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> Uhm, no.  It's not.  Unless the host provides actual entropy
>> information, you have a security hole.
> 
> Huh?  We just can't assume it adds entropy.  AFAICT rngd -H0 is what we want 
> here.

We can, if it comes from /dev/random.

>>> If we use /dev/random in the host, we risk a DoS.  But since /dev/random
>>> is 0666 on my system, perhaps noone actually cares?
>> There is no point in feeding the host /dev/urandom to the guest (except 
>> for seeding, which can be handled through other means); it will do its 
>> own mixing anyway.
> 
> Seeding is good, but unlikely to be done properly for first boot of some 
> standard virtualized container.  In practice, feeding /dev/urandom from the 
> host will make /dev/urandom harder to predict in the guest.

Only up to a point.

>> The reason to provide anything at all from the host 
>> is to give it "golden" entropy bits.
> 
> But you did not address the DoS question: can we ignore it?  Or are we trading 
> off a DoS in the host against a potential security weakness in the guest?
> 
> If so, how do we resolve it?

I don't think you have a DoS situation at all.  The worst thing is that 
you don't have any entropy available at all, at which point /dev/urandom 
is as insecure as it ever is.

	-hpa

