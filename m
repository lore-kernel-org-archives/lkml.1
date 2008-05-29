Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYE2PCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYE2PCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbYE2PBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:01:47 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59013 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbYE2PBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:01:46 -0400
Message-ID: <483EC576.8080702@bull.net>
Date: Thu, 29 May 2008 17:02:14 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ipc/sem.c: remove unused entries from struct sem_queue
References: <200805241637.m4OGbBVo006252@mail.q-ag.de>
In-Reply-To: <200805241637.m4OGbBVo006252@mail.q-ag.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> sem_queue.sma and sem_queue.id were never used, the attached
> patch removes them.
> 
> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>

Reviewed-By: Nadia Derbey <Nadia.Derbey@bull.net>

> ---
>  include/linux/sem.h |    2 --
>  ipc/sem.c           |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index 6a1af1b..87756ef 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -107,8 +107,6 @@ struct sem_queue {
>  	struct sem_undo *	undo;	 /* undo structure */
>  	int    			pid;	 /* process id of requesting process */
>  	int    			status;	 /* completion status of operation */
> -	struct sem_array *	sma;	 /* semaphore array for operations */
> -	int			id;	 /* internal sem id */
>  	struct sembuf *		sops;	 /* array of pending operations */
>  	int			nsops;	 /* number of operations */
>  	int			alter;   /* does the operation alter the array? */
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 211632e..8cd96f1 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1160,12 +1160,10 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
>  	 * task into the pending queue and go to sleep.
>  	 */
>  		
> -	queue.sma = sma;
>  	queue.sops = sops;
>  	queue.nsops = nsops;
>  	queue.undo = un;
>  	queue.pid = task_tgid_vnr(current);
> -	queue.id = semid;
>  	queue.alter = alter;
>  	if (alter)
>  		append_to_queue(sma ,&queue);



