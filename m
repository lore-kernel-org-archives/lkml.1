Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXEIJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXEIJ1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXEIJ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:27:05 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:27859 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753294AbXEIJ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:27:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KGgn98RMjmGykMFypRbCoZnPHvvkXuv9jnNhx9eXTJLGUXy2L+pLMEiSCwiAuRlHUx8DhCkNvzIzXfwr0ui71PRazQ07bGY0qebOfNkBh2yAzUk7u2TiZpJndqYIJquj03CMvltUMl3gXX4PQerWZAM0bXnXyMOIH0n08RXwYho=  ;
X-YMail-OSG: VT526qkVM1kPF.nYuqkifDZu06E9DeVpep71PBdFKp_Ghm3LbGR8CuKWExO1riNLI5zMgFqZZg--
Message-ID: <464193DB.70205@yahoo.com.au>
Date: Wed, 09 May 2007 19:26:51 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Rientjes <rientjes@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>	<20070508163452.8b71f682.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>	<20070508190800.1334b968.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com> <20070509102134.5d722386@the-village.bc.nu>
In-Reply-To: <20070509102134.5d722386@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>It's still ambiguous.  A much more explicit title that nobody could argue 
>>with would be "do not use the 'volatile' keyword as a type qualifier for 
>>an object."
> 
> 
> Except when you do. The kernel uses the C volatile in various places
> itself for specific good reasons (and some for historical bad ones)
> 
> Perhaps a closer summary would be
> 
> Do Not Use Volatile
> -------------------
> 
> 1.	volatile is not a locking mechanism
> 
> Volatile does not define sufficiently sane or strong semantics for
> locking. The kernel has proper locking mechanisms which also act as
> compiler fetch/store barriers and where neccessary hardware barriers for
> SMP systems. The kernel knows about all the corner cases, you probably
> don't.
> 
> 2.	volatile is not needed for mmio space
> 
> I/O memory access are done via readb/writeb and friends. They deal with
> volatility themselves so you don't have to. They may nor may not use
> volatile internally to their implementation, but that is none of your
> business.
> 
> 3.	volatile is not atomic
> 
> Using volatile does not guarantee atomic behaviour. This often requires
> special instructions or code sequences too. We have atomic_t and the
> atomic_* operators for this.
> 
> 4.	volatile is not a store or read barrier
> 
> Using volatile is not always sufficient to order accesses on SMP or to
> ensure things execute in the order expected. Instead the kernel provides
> a set of barrier operations which have clearly defined semantics on all
> systems. Make use of rmb, wmb, barrier, smp_wmb etc instead
> 
> When Might You Need volatile ?
> ------------------------------
> 
> When you are implementing the locking primitives on a new platform. When
> you are implementing the I/O and atomic prmitives on a new platform. Also
> in inline gcc assembler where "volatile" is used for subtly different
> purposes.

Is there a good reason for using volatile in atomic/locking primitives?
AFAIKS there is not.

-- 
SUSE Labs, Novell Inc.
