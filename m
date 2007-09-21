Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXIUJ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXIUJ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbXIUJ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:56:22 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:52876 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXIUJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:56:21 -0400
Message-ID: <46F39526.802@fr.ibm.com>
Date: Fri, 21 Sep 2007 11:55:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 3/3] user.c: #ifdef ->mq_bytes
References: <20070921094010.GC6812@localhost.sw.ru>
In-Reply-To: <20070921094010.GC6812@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey !

Alexey Dobriyan wrote:
> for those who deselect POSIX message queues.
> 
> Reduces SLAB size of user_struct from 64 to 32 bytes here,
> SLUB size -- from 40 bytes to 32 bytes.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  include/linux/sched.h |    2 ++
>  kernel/user.c         |    2 --
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -583,8 +583,10 @@ struct user_struct {
>  	atomic_t inotify_watches; /* How many inotify watches does this user have? */
>  	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
>  #endif
> +#ifdef CONFIG_POSIX_MQUEUE
>  	/* protected by mq_lock	*/
>  	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
> +#endif
>  	unsigned long locked_shm; /* How many pages of mlocked shm ? */

while you are it, it seems possible to #ifdef locked_shm also. it's a bit more 
complex because the code is mm/ and there are some links with the hugetlbfs 
also.

Cheers,

C.

>  #ifdef CONFIG_KEYS
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -44,7 +44,6 @@ struct user_struct root_user = {
>  	.processes	= ATOMIC_INIT(1),
>  	.files		= ATOMIC_INIT(0),
>  	.sigpending	= ATOMIC_INIT(0),
> -	.mq_bytes	= 0,
>  	.locked_shm     = 0,
>  #ifdef CONFIG_KEYS
>  	.uid_keyring	= &root_user_keyring,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

