Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYESJLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYESJLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYESJLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:11:06 -0400
Received: from gw.goop.org ([64.81.55.164]:38210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYESJLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:11:05 -0400
Message-ID: <48314419.4080606@goop.org>
Date: Mon, 19 May 2008 10:10:49 +0100
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
References: <482C8595.5030509@garzik.org> <200805171628.03801.rusty@rustcorp.com.au> <482E8D75.10606@goop.org> <200805191905.11452.rusty@rustcorp.com.au>
In-Reply-To: <200805191905.11452.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 17 May 2008 17:47:01 Jeremy Fitzhardinge wrote:
>   
>> But the host->guest protocol should include the number of bits estimated
>> entropy along with the bits themselves.
>>     
>
> If we go down that path, we have to come up with a way of feeding that 
> information to guest userspace.  Patches welcome.  If we meanwhile assume 
> entropy == #bits, it fits the current /dev/hwrng model, and we can add an 
> entropy count later if we want to change that.
>   

Really?  Wouldn't guest userspace just use /dev/random as usual, which I 
think does have an ioctl to give that kind of information?  And the 
interfaces do allow things injecting entropy into the kernel pool to 
provide entropy estimates along with the actual bits themselves.

> I'll change my lguest implementation to suck from /dev/random, since noone 
> else seems to consider its depletion to be a real issue.  It's no worse than 
> what any other process can do.
>   

Well, I think having some rate-limiting controls would be nice to have, 
but certainly not a show-stopper for a first implementation.

    J
