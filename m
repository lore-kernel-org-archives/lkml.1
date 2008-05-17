Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYEQEx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYEQEx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYEQExT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:53:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYEQExS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:53:18 -0400
Message-ID: <482E6417.8040602@zytor.com>
Date: Fri, 16 May 2008 21:50:31 -0700
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
References: <482C8595.5030509@garzik.org> <200805161539.59739.rusty@rustcorp.com.au> <1210934981.6381.1.camel@johannes.berg> <200805171446.39814.rusty@rustcorp.com.au>
In-Reply-To: <200805171446.39814.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 16 May 2008 20:49:41 Johannes Berg wrote:
>>> +
>>> +/* Our random number generator device reads from /dev/urandom into the Guest's
>>> + * input buffers.  The usual case is that the Guest doesn't want random numbers
>>> + * and so has no buffers although /dev/urandom is still readable, whereas
>>> + * console is the reverse. 
>> Is it really a good idea to use the hosts /dev/urandom to fill the
>> guests /dev/random?
> 
> Technically it's up to rngd in the guest to decide whether to feed entropy
> or not (ie. /dev/urandom or /dev/random).

Uhm, no.  It's not.  Unless the host provides actual entropy 
information, you have a security hole.

> If we use /dev/random in the host, we risk a DoS.  But since /dev/random
> is 0666 on my system, perhaps noone actually cares?

/dev/random	= give me actual entropy, if you have some.
/dev/urandom	= give me what you have, regardless of quality.

There is no point in feeding the host /dev/urandom to the guest (except 
for seeding, which can be handled through other means); it will do its 
own mixing anyway.  The reason to provide anything at all from the host 
is to give it "golden" entropy bits.

	-hpa
