Return-Path: <linux-kernel-owner+w=401wt.eu-S937568AbXFHFAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937568AbXFHFAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXFHFAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:00:32 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:39655 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXFHFAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:00:31 -0400
Message-ID: <4668E25D.3010109@cosmosbay.com>
Date: Fri, 08 Jun 2007 07:00:13 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/8] fdmap v2 - fdmap core
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1> <4668E106.9040509@cosmosbay.com>
In-Reply-To: <4668E106.9040509@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 08 Jun 2007 07:00:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> 
> struct fd_map {
>     /*
>      * read mostly part
>      */
>     unsigned int base;   /* 0x00 */
>     unsigned int size;   /* 0x04 */
>     struct list_head slist; /* 0x08 */
>     struct list_head *slots; /* 0x18 */
>     unsigned long *map; /* 0x28 */
>     void (*freecb)(void *, struct fd_map *); /* 0x30 */
>     void *freecb_priv; /* 0x38 */
> 
>     /*
>      * written part on a separate cache line in SMP
>      */
>     unsigned int fdnext ____cacheline_aligned_in_smp; /* 0x40 */
> 
>     struct fd_map *next;  /* 0x48 */
>     struct rcu_head rcu; /* 0x50 */
> };

Well, offsets are wrong but layout OK

struct fd_map {
     /*
      * read mostly part
      */
     unsigned int base;   /* 0x00 */
     unsigned int size;   /* 0x04 */
     struct list_head slist; /* 0x08 */
     struct list_head *slots; /* 0x18 */
     unsigned long *map; /* 0x20 */
     void (*freecb)(void *, struct fd_map *); /* 0x28 */
     void *freecb_priv; /* 0x30 */
	/* one 8 bytes hole */

     /*
      * written part on a separate cache line in SMP
      */
     unsigned int fdnext ____cacheline_aligned_in_smp; /* 0x40 */

     struct fd_map *next;  /* 0x48 */
     struct rcu_head rcu; /* 0x50 */
}; /* size 0x60 , aligned to 0x80 */

