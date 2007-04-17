Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXDQR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXDQR2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161155AbXDQR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:28:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10495 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbXDQR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:28:19 -0400
Date: Tue, 17 Apr 2007 10:29:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Introduce a handy list_first_entry macro
Message-Id: <20070417102945.052796d5.randy.dunlap@oracle.com>
In-Reply-To: <4624AD20.6050009@sw.ru>
References: <4624AD20.6050009@sw.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 15:18:56 +0400 Pavel Emelianov wrote:

> There are many places in the kernel where the construction like
> 
>    foo = list_entry(head->next, struct foo_struct, list);
> 
> are used. 
> The code might look more descriptive and neat if using the macro
> 
>    list_first_entry(head, type, member) \
>              list_entry((head)->next, type, member)
> 
> Here is the macro itself and the examples of its usage in the
> generic code. If it will turn out to be useful, I can prepare
> the set of patches to inject in into arch-specific code, drivers,
> networking, etc.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> Signed-off-by: Kirill Korotaev <dev@openvz.org>
> 
> ---
> diff --git a/include/linux/list.h b/include/linux/list.h
> index fd59659..71318fc 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -425,6 +425,9 @@ static inline void list_splice_init_rcu(
>  #define list_entry(ptr, type, member) \
>  	container_of(ptr, type, member)
>  
> +#define list_first_entry(ptr, type, member) \
> +	list_entry((ptr)->next, type, member)
> +

Please provide kernel-doc for that like the rest of list.h has.

>  /**
>   * list_for_each	-	iterate over a list
>   * @pos:	the &struct list_head to use as a loop cursor.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
