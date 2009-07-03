Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZGCPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZGCPiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZGCPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:38:11 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:44354 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbZGCPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:38:10 -0400
Message-ID: <4A4E25BB.8060408@gmail.com>
Date: Fri, 03 Jul 2009 17:37:31 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@elte.hu,
       jolsa@redhat.com, a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, eric.dumazet@gmail.com,
       Paul.McKenney@us.ibm.com
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
References: <20090703152951.GA28837@gondor.apana.org.au>
In-Reply-To: <20090703152951.GA28837@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 17:37:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu a écrit :
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
>> Why don't we create a read_lock without acquire semantic instead (e.g.
>> read_lock_nomb(), or something with a better name like __read_lock()) ?
>> On architectures where memory barriers are needed to provide the acquire
>> semantic, it would be faster to do :
>>
>> __read_lock();
>> smp_mb();
>>
>> than :
>>
>> read_lock(); <- e.g. lwsync + isync or something like that
>> smp_mb(); <- full sync.
> 
> Hmm, why do we even care when read_lock should just die?
> 
> Cheers,

+1 :)

Do you mean using a spinlock instead or what ?

Also, how many arches are able to have a true __read_lock()
(or __spin_lock() if that matters), without acquire semantic ?
