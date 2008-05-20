Return-Path: <linux-kernel-owner+w=401wt.eu-S933292AbYETO4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbYETO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbYETOz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:55:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765148AbYETOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:55:56 -0400
Date: Tue, 20 May 2008 07:54:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
cc: Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
In-Reply-To: <20080520142727.GC4843@redhat.com>
Message-ID: <alpine.LFD.1.10.0805200752580.32253@woody.linux-foundation.org>
References: <20080502182745.GL14976@parisc-linux.org> <20080501133209.2c04dad0@infradead.org> <20080502184922.GM14976@parisc-linux.org> <20080520032448.GA19348@redhat.com> <20080520071458.707d6e90@infradead.org> <20080520142727.GC4843@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Dave Jones wrote:
> 
> Like this ?  (I don't have a -mm handy, so guessed based on mm-commits mail,
>   patch uncompiled, but should dtrt if I understood your diff correctly)
> 
> diff --git a/lib/list_debug.c b/lib/list_debug.c
> index 4350ba9..d8dee53 100644
> --- a/lib/list_debug.c
> +++ b/lib/list_debug.c
> @@ -21,16 +21,14 @@ void __list_add(struct list_head *new,
>  			      struct list_head *next)
>  {
>  	if (unlikely(next->prev != prev)) {
> -		printk(KERN_ERR "list_add corruption. next->prev should be "
> +		WARN(1, "list_add corruption. next->prev should be "
>  			"prev (%p), but was %p. (next=%p).\n",
>  			prev, next->prev, next);
> -		BUG();
>  	}

I think Arjan meant like

	WARN(next->prev != prev,
		"list_add corruption. next->prev should be "
		"prev (%p), but was %p. (next=%p).\n",
		prev, next->prev, next);

without any "if()" statement at all.

			Linus
