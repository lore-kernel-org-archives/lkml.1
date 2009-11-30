Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZK3K2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZK3K2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK3K2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:28:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:52249 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZK3K2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:28:47 -0500
Message-ID: <4B139E3D.1020905@collabora.co.uk>
Date: Mon, 30 Nov 2009 10:28:13 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hw_random: core updates to allow more efficient drivers
References: <1259177252.2858.17.camel@calx> <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk> <1259197403.2858.88.camel@calx> <200911282035.26847.rusty@rustcorp.com.au>
In-Reply-To: <200911282035.26847.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:

> And might as well just #defube RNG_BUFFSIZE SMP_CACHE_BYTES (or use
> SMP_CACHE_BYTES here and sizeof() elsewhere).

This can lead to a rather small (4 byte) buffer on some systems, however
I don't know if in practice a tiny buffer or a big one would be better
for performance on those machines. I guess if its a problem someone can
patch the code to allocate a minimum of (say) 16 bytes in future...

so changed :)

>>> +		if (!data_avail) {
>>> +			bytes_read = rng_get_data(current_rng, rng_buffer,
>>> +				RNG_BUFFSIZE, !(filp->f_flags & O_NONBLOCK));
>> No need to pass rng_buffer to the helper as there's only one with global
>> scope.
> 
> Naah, I like the separation; it matches the rest of the kernel and means we
> can get funky with buffer management in 10 years time when we rewrite this
> again.

Tweaked to use sizeof().
