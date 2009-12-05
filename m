Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZLEUa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZLEUa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZLEUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:30:25 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:58184 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbZLEUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:30:24 -0500
X-Trace: 302073934/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAAFpRGktQKW/F/2dsb2JhbAAI1GWEMwQ
X-IronPort-AV: E=Sophos;i="4.47,347,1257120000"; 
   d="scan'208";a="302073934"
Date: Sat, 5 Dec 2009 20:30:21 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric Paris <eparis@redhat.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 12/15] ima-path-check rework
In-Reply-To: <20091204204816.18286.15738.stgit@paris.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.0912052026440.6368@sister.anvils>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
 <20091204204816.18286.15738.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Eric Paris wrote:

I've not checked through this whole patch and your whole patchset,
but certainly when IMA came in, I felt (and said) that these calls
should be done at a lower level, so as not to affect each filesystem.
So I thoroughly approve of the direction of your patchset, even
though I cannot vouch for the details of it.  Thank you, Eric.

Hugh

> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -29,7 +29,6 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/swap.h>
> -#include <linux/ima.h>
>  
>  static struct vfsmount *shm_mnt;
>  
> @@ -2655,8 +2654,6 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
>  	if (!file)
>  		goto put_dentry;
>  
> -	ima_counts_get(file);
> -
>  #ifndef CONFIG_MMU
>  	error = ramfs_nommu_expand_for_mapping(inode, size);
>  	if (error) {
