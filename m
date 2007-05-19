Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXEST2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXEST2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbXEST2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:28:30 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:51961 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbXEST23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:28:29 -0400
Message-ID: <464F4FD1.5030308@simon.arlott.org.uk>
Date: Sat, 19 May 2007 20:28:17 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       michal@logix.cz, ioe-lkml@rameria.de
Subject: Re: [PATCH (v2)] crypto: Remove pointless padlock module
References: <4633DB56.6070000@simon.arlott.org.uk> <4633FBFF.7050202@oracle.com> <463450C6.5060103@simon.arlott.org.uk> <20070518064500.GA16394@gondor.apana.org.au>
In-Reply-To: <20070518064500.GA16394@gondor.apana.org.au>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/07 07:45, Herbert Xu wrote:
> On Sun, Apr 29, 2007 at 09:01:10AM +0100, Simon Arlott wrote:
>> When this is compiled in it is run too early to do anything useful:
>> [    6.052000] padlock: No VIA PadLock drivers have been loaded.
>> [    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
>> [    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
>>
>> When it's a module it isn't doing anything special, the same functionality 
>> can be provided in userspace by "probeall padlock padlock-aes padlock-sha" 
>> in modules.conf if it is required.
> 
> BTW, I noticed that this prevented CRYPTO_ALGAPI from being marked as m
> since it was selected by CRYPTO_DEV_PADLOCK.  So I'm turning it into a
> tristate again.

It should be a bool that doesn't select anything, the AES and SHA modules 
will select CRYPTO_ALGAPI. It could also depend on MVIAC3_2 || MVIA_C7 
instead of X86_32.

-- 
Simon Arlott
