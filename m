Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbXEUSu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbXEUSu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbXEUSuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:50:19 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:38711 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbXEUSuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:50:18 -0400
Message-ID: <4651E992.9080205@cosmosbay.com>
Date: Mon, 21 May 2007 20:48:50 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com> <4651E1D4.6010705@cosmosbay.com> <4651E44A.9070301@redhat.com>
In-Reply-To: <4651E44A.9070301@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 May 2007 20:48:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
>> Do you mean POSIX allowed to mix PROCESS_PRIVATE and PROCESS_SHARED
>> condvar and mutexes ? Seems silly to me :(
> 

> Don't judge what you don't understand.

Yes, I kindly apologise for this crime.

 > If all waiters are always in one
> process but the notifiers can be in different processes, this setup
> might make a lot of sense.

Thanks for providing this information.

I assume in this case the condvar is PSHARED, while mutex could be/is PRIVATE ?

I wonder how old (assuming all shared) code could work, since the notifier 
would call FUTEX_CMP_REQUEUE giving a target address outside of this process vm ?

My understanding (probably bad, since I know nothing about POSIX as you mentioned)

- Old code could not use FUTEX_CMP_REQUEUE if mutex was private.
-> Old code was using a normal FUTEX_WAKE in this case.

So I repeat my question : Should we really add yer another futex command in 
kernel for a corner case ?

Thanks
