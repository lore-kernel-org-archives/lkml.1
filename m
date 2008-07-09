Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYGIOQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYGIOQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYGIOQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:16:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:55948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYGIOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:16:35 -0400
Date: Wed, 9 Jul 2008 07:16:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bruno Santos <bsantos@av.it.pt>
Cc: linux-kernel@vger.kernel.org, bsantos@av.it.pt
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
Message-ID: <20080709071635.5c5ecc0f@infradead.org>
In-Reply-To: <4874B979.4020608@av.it.pt>
References: <4874B979.4020608@av.it.pt>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 14:13:29 +0100
Bruno Santos <bsantos@av.it.pt> wrote:

> So far the machine I'm testing this (Core2 Duo) it's been up to
> almost 24H.
> 
> It seems the patch got screwed by the mailer, so I'm posting it again.
> 
> 
>  From 343d08a5d172d103e49c77e5580a45f02fab2b5e Mon Sep 17 00:00:00
> 2001 From: Bruno Santos <bsantos@av.it.pt>
> Date: Tue, 8 Jul 2008 23:40:53 +0100
> Subject: [PATCH] semaphore lockless fastpath
> 
> 
> Signed-off-by: Bruno Santos <bsantos@av.it.pt>
> ---
>  include/linux/semaphore.h |    4 +-
>  kernel/semaphore.c        |  131 
> +++++++++++++++++++++++++--------------------
>  2 files changed, 75 insertions(+), 60 deletions(-)
> 
> diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
> index 9cae64b..d7850f0 100644
> --- a/include/linux/semaphore.h
> +++ b/include/linux/semaphore.h
> @@ -14,15 +14,15 @@
>  
>  /* Please don't access any members of this structure directly */
>  struct semaphore {
> +    atomic_t        count;
>      spinlock_t        lock;
> -    unsigned int        count;
>      struct list_head    wait_list;
>  };
> 



hi,

not to ruin the party but... how is this lockless? An atomic variable
is every bit a "lock" as a spinlock is... and very much equally
expensive as well for most cases ;-(
