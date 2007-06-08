Return-Path: <linux-kernel-owner+w=401wt.eu-S937913AbXFHFZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937913AbXFHFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934860AbXFHFZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:25:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4542 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934838AbXFHFZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:25:12 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 22:25:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/8] fdmap v2 - fdmap core
In-Reply-To: <4668E25D.3010109@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706072222340.3454@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
 <4668E106.9040509@cosmosbay.com> <4668E25D.3010109@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Eric Dumazet wrote:

> struct fd_map {
>     /*
>      * read mostly part
>      */
>     unsigned int base;   /* 0x00 */
>     unsigned int size;   /* 0x04 */
>     struct list_head slist; /* 0x08 */
>     struct list_head *slots; /* 0x18 */
>     unsigned long *map; /* 0x20 */
>     void (*freecb)(void *, struct fd_map *); /* 0x28 */
>     void *freecb_priv; /* 0x30 */
> 	/* one 8 bytes hole */
> 
>     /*
>      * written part on a separate cache line in SMP
>      */
>     unsigned int fdnext ____cacheline_aligned_in_smp; /* 0x40 */
> 
>     struct fd_map *next;  /* 0x48 */
>     struct rcu_head rcu; /* 0x50 */
> }; /* size 0x60 , aligned to 0x80 */

Wait, that's wrong. Mostly written fields are fdnext and slist, and now 
count. The rcu and next are written only on free. I'd move next down, move 
slist up, and place count up.



- Davide


