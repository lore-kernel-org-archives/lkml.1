Return-Path: <linux-kernel-owner+w=401wt.eu-S1760807AbZFQWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbZFQWWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZFQWWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:22:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:44303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbZFQWWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:22:42 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, dm-devel@redhat.com
Date: Thu, 18 Jun 2009 08:22:36 +1000 (EST)
Message-ID: <0f79c2d4513c50184383e223d3d2ee97.squirrel@neil.brown.name>
In-Reply-To: <4A396195.8060503@goop.org>
References: <4A396195.8060503@goop.org>
Subject: Re: init_emergency_isa_pool calling mempool_create in non-sleeping 
     context
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You wanted dm-devel@redhat.com, not linux-raid@vger.kernel.org.

NeilBrown


On Thu, June 18, 2009 7:35 am, Jeremy Fitzhardinge wrote:
> I just saw this when booting a current linux-2.6.git kernel
> (3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8).
> .config and full bootlog attached.
>
> BUG: sleeping function called from invalid context at
> /home/jeremy/git/linux/mm/slab.c:3029
> in_atomic(): 1, irqs_disabled(): 0, pid: 388, name: lvm
> Pid: 388, comm: lvm Not tainted 2.6.30 #225
> Call Trace:
>  [<ffffffff81137a65>] ? __init_rwsem+0x29/0x39
>  [<ffffffff81035346>] __might_sleep+0x110/0x112
>  [<ffffffff810acf07>] kmem_cache_alloc+0x38/0x12b
>  [<ffffffff810a71d4>] ? mempool_alloc_pages_isa+0x0/0x10
>  [<ffffffff8108a5df>] mempool_create_node+0x2f/0x152
>  [<ffffffff8108a31c>] ? mempool_free_pages+0x0/0xb
>  [<ffffffff8108a70f>] mempool_create+0xd/0xf
>  [<ffffffff810a71ad>] init_emergency_isa_pool+0x28/0x4f
>  [<ffffffff81127b90>] blk_queue_bounce_limit+0x40/0x56
>  [<ffffffffa00f856c>] dm_table_set_restrictions+0x82/0xa6 [dm_mod]
>  [<ffffffffa00f6415>] dm_swap_table+0x132/0x15a [dm_mod]
>  [<ffffffffa00faf61>] dev_suspend+0xfd/0x177 [dm_mod]
>  [<ffffffffa00fb959>] dm_ctl_ioctl+0x252/0x2a2 [dm_mod]
>  [<ffffffffa00fae64>] ? dev_suspend+0x0/0x177 [dm_mod]
>  [<ffffffff810bd4c0>] vfs_ioctl+0x2a/0x77
>  [<ffffffff810bd9b4>] do_vfs_ioctl+0x4a7/0x4fa
>  [<ffffffff810bda5e>] sys_ioctl+0x57/0x7a
>  [<ffffffff81011042>] system_call_fastpath+0x16/0x1b
>
> 	J
>
>

