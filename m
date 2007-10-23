Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbXJWOJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbXJWOJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJWOJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:09:30 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:43337 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXJWOJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:09:30 -0400
Date: Tue, 23 Oct 2007 10:08:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC/PATCH 2/5] rt: list_splice2
In-Reply-To: <20071023120744.879638000@chello.nl>
Message-ID: <Pine.LNX.4.58.0710231005540.29506@gandalf.stny.rr.com>
References: <20071023120357.782284000@chello.nl> <20071023120744.879638000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
On Tue, 23 Oct 2007, Peter Zijlstra wrote:
>
>  /**
> @@ -341,7 +341,13 @@ static inline void __list_splice(struct
>  static inline void list_splice(struct list_head *list, struct list_head *head)
>  {
>  	if (!list_empty(list))
> -		__list_splice(list, head);
> +		__list_splice(list, head, head->next);
> +}
> +


> Index: linux-2.6/lib/lock_list.c
> ===================================================================
> --- linux-2.6.orig/lib/lock_list.c
> +++ linux-2.6/lib/lock_list.c
> @@ -128,7 +128,7 @@ void lock_list_splice_init(struct lock_l
>  	lock = __lock_list_reverse(list);
>  	if (!list_empty(&list->head)) {
>  		spin_lock_nested(&head->lock, LOCK_LIST_NESTING_NEXT);
> -		__list_splice(&list->head, &head->head);
> +		__list_splice(&list->head, &head->head, head->head.next);

Can't this just now be list_splice and not __list_splice?

Yes it tests for list_empty again, but that should (hopefully) be
optimized out.

-- Steve

>  		INIT_LIST_HEAD(&list->head);
>  		spin_unlock(&head->lock);
>  	}
>
> --
>
>
>
