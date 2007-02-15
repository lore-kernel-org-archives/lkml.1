Return-Path: <linux-kernel-owner+w=401wt.eu-S965515AbXBOOhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbXBOOhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965512AbXBOOhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:37:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:9009 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508AbXBOOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UdJJaNJFAP1UU98U5YgPYnhFqNQN4D/cawgAGxVszGMkzweLKQLkaFvoePuHP4p8C2SP5v2pId6JrhRGNxhSHr4mcQDWdUT3RO9YQUlMi75jV2vpuxs6DjrYO0vJ3lhQIMq/idI/Sw74XKfkZlTjrhersbwjFw27GchO6+ogEeY=
Message-ID: <45D47020.1010309@googlemail.com>
Date: Thu, 15 Feb 2007 15:37:20 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
> 
> Will appear later at
> 
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
> 
> 

BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
in_atomic():1, irqs_disabled():0
1 lock held by artsd/3819:
 #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c011db4a>] __might_sleep+0xc9/0xcf
 [<c017c37a>] kmem_cache_zalloc+0x28/0xe5
 [<c01d8c7d>] do_shmat+0x111/0x372
 [<c0109151>] sys_ipc+0x148/0x1b5
 [<c010432c>] syscall_call+0x7/0xb
 =======================

0xc01d5b7c is in ipc_lock (/mnt/md0/devel/linux-mm/ipc/util.c:684).
679             spin_lock(&out->lock);
680
681             /* ipc_rmid() may have already freed the ID while ipc_lock
682              * was spinning: here verify that the structure is still valid
683              */
684             if (out->deleted) {
685                     spin_unlock(&out->lock);
686                     rcu_read_unlock();
687                     return NULL;
688             }


http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-mm1/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-mm1/mm-config

[michal@euridica linux-work3]$ quilt patches mm/slab.c
patches/origin.patch
patches/slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
patches/slab-use-cpu_lock_.patch
patches/slab-shutdown-cache_reaper-when-cpu-goes-down.patch
[michal@euridica linux-work3]$ quilt patches ipc/util.c
patches/origin.patch

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
