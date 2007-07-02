Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbXGBQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbXGBQJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXGBQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 12:09:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:18590 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbXGBQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 12:09:40 -0400
Date: Mon, 2 Jul 2007 16:33:56 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: William Tambe <tambewilliam@gmail.com>
cc: Stas Sergeev <stsp@aknet.ru>, linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
In-Reply-To: <468562F6.4010604@gmail.com>
Message-ID: <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
References: <468562F6.4010604@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAdGFtYmV3aWxsaWFtQGdtYWlsLmNvbQBzdHNwQGFrbmV0LnJ1AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, William Tambe wrote:

> I read a post that you made about not being able to expand anonymous shared
> mapping with mremap(). And I am actually having that issue now.

I guess you're referring to the thread at
http://lkml.org/lkml/2004/6/16/155
and you're asking either Stas or me.

> 
> You made the post in 2004 and we are now in 2007. I would like to know if that
> feature was added because the code below always fail with bus error on my
> machine. I use glibc 2.5

You've answered your own question: we did not make the change Stas
suggested, IIRC because I remained a little uneasy with that change
in behaviour, and nobody else spoke up for it.

I haven't given it any thought since then:
do you have a good case for us to reconsider it?

Hugh

> 
> Thank you for helping.
> 
> #define _GNU_SOURCE
> #include <sys/mman.h>
> #include <unistd.h>
> 
> #include <stdio.h>
> 
> main() {
>         void *ptr;
>         if ((ptr=mmap(0, 4096, PROT_READ|PROT_WRITE,
>                 MAP_ANONYMOUS|MAP_SHARED|MAP_GROWSDOWN, 0, 0)) == -1) {
>                 printf("failed to mmap\n");
>                 return;
>         }
> 
>         if ((ptr=mremap(ptr, 4096, 8192, MREMAP_MAYMOVE)) == -1) {
>                 printf("failed to mremap\n");
>                 return;
>         }
> 
>         //why does this failed. I am well in the interval [4096, 8192]
>         *(unsigned int *)(ptr + 4096 + 8)= 10;
> }
