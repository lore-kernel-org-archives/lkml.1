Return-Path: <linux-kernel-owner+w=401wt.eu-S1030840AbXDNJmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030840AbXDNJmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 05:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030842AbXDNJmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 05:42:06 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:44589 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030840AbXDNJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 05:42:04 -0400
Message-ID: <4620A13F.6060502@cosmosbay.com>
Date: Sat, 14 Apr 2007 11:39:11 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
CC: kernel-janitors@lists.osdl.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [KJ][PATCH 03/04]use set_current_state in fs
References: <20070414084956.GD14084@arun.site>
In-Reply-To: <20070414084956.GD14084@arun.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 14 Apr 2007 11:39:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milind Arun Choudhary a écrit :
> use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/nfs
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
> 
> 
> ---
>  idmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
> index 9d4a6b2..054ca15 100644
> --- a/fs/nfs/idmap.c
> +++ b/fs/nfs/idmap.c
> @@ -272,7 +272,7 @@ nfs_idmap_id(struct idmap *idmap, struct idmap_hashtable *h,
>  	set_current_state(TASK_UNINTERRUPTIBLE);
>  	mutex_unlock(&idmap->idmap_im_lock);
>  	schedule();
> -	current->state = TASK_RUNNING;
> +	set_current_state(TASK_RUNNING);
>  	remove_wait_queue(&idmap->idmap_wq, &wq);
>  	mutex_lock(&idmap->idmap_im_lock);

Probably a dumb question, so please forgive me.

Why are you  forcing a memory barrier here, (and also on your other patches).

Is'nt a  __set_current_state(TASK_RUNNING); appropriate ?


