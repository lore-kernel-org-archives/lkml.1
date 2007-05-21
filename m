Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXEUSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXEUSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXEUSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:16:50 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48578 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEUSQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:16:50 -0400
Message-ID: <4651E1D4.6010705@cosmosbay.com>
Date: Mon, 21 May 2007 20:15:48 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com>
In-Reply-To: <4651D628.1070206@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 May 2007 20:15:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> This one is a big problem:
> 
> If I understand the code correctly, a FUTEX_CMP_REQUEUE from a private
> futex will add the waiters to the other futex as a private futex.  And
> similarly for shared.
> 
> I.e., it is not possible to have one futex private and the other shared.
>  This is a huge problem.  The shared/private status of a conditional
> variable and the mutex used with it don't have to match.  But this is
> where FUTEX_CMP_REQUEUE is used.
> 
> If this is not changed (assuming I'm right with my analysis of the
> kernel code) this means mutexes and condvars will not be able to use
> private futexes.

Do you mean POSIX allowed to mix PROCESS_PRIVATE and PROCESS_SHARED condvar 
and mutexes ? Seems silly to me :(

> 
> What would be needed is an additional parameter for FUTEX_CMP_REQUEUE
> and FUTEX_CMP_REQUEUE_PI which specifies the state (shared/private) of
> the target futex.  The original futex' state is encoded in the command
> (the FUTEX_PRIVATE_FLAG ORed to FUTEX_CMP_REQUEUE*).
> 

Well, I guess it should be easy to add this if really necessary.


