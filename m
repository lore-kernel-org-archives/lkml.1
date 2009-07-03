Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZGCPwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZGCPwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZGCPwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:52:01 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41475 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbZGCPv7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:51:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAKHETUpMQWU3/2dsb2JhbACBUMx0hBIFgTo
Date: Fri, 3 Jul 2009 11:47:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, jolsa@redhat.com,
       a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, Paul.McKenney@us.ibm.com
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703154700.GD10256@Krystal>
References: <20090703152951.GA28837@gondor.apana.org.au> <4A4E25BB.8060408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A4E25BB.8060408@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:41:37 up 125 days, 12:07,  4 users,  load average: 0.71, 0.84,
	0.70
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (eric.dumazet@gmail.com) wrote:
> Herbert Xu a écrit :
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> >> Why don't we create a read_lock without acquire semantic instead (e.g.
> >> read_lock_nomb(), or something with a better name like __read_lock()) ?
> >> On architectures where memory barriers are needed to provide the acquire
> >> semantic, it would be faster to do :
> >>
> >> __read_lock();
> >> smp_mb();
> >>
> >> than :
> >>
> >> read_lock(); <- e.g. lwsync + isync or something like that
> >> smp_mb(); <- full sync.
> > 
> > Hmm, why do we even care when read_lock should just die?
> > 
> > Cheers,
> 
> +1 :)
> 
> Do you mean using a spinlock instead or what ?
> 

I think he meant RCU.

> Also, how many arches are able to have a true __read_lock()
> (or __spin_lock() if that matters), without acquire semantic ?

At least PowerPC, MIPS, recent ARM, alpha.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
