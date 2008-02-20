Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYBTNwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYBTNwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYBTNwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:52:46 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40517 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbYBTNwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:52:45 -0500
To: bunk@kernel.org, clameter@sgi.com, penberg@cs.helsinki.fi, mpm@selenic.com
Subject: Re: mm/slub.c: inconsequent NULL checking
X-IlohaMail-Blah: penberg@cs.helsinki.fi
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.12+pk-11 (On: iloha.cs.Helsinki.FI)
In-Reply-To: <20080219224922.GO31955@cs181133002.pp.htv.fi>
Message-ID: <6f8gTuy3.1203515564.2078250.penberg@cs.helsinki.fi>
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Wed, 20 Feb 2008 15:52:44 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian,

On 2/20/2008, "Adrian Bunk" <bunk@kernel.org> wrote:
> The Coverity checker spotted the following inconsequent NULL checking
> introduced by commit 8ff12cfc009a2a38d87fa7058226fe197bb2696f:
> 
> <--  snip  -->
> 
> ...
> static inline int is_end(void *addr)
> {
>         return (unsigned long)addr & PAGE_MAPPING_ANON;
> }
> ...
> static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
> {
> ...
>         if (c->freelist)    <----------------------------------------
>                 stat(c, DEACTIVATE_REMOTE_FREES);

I spotted this too. c->freelist should never be NULL so why not send a
patch to Christoph?
