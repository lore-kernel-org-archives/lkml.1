Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYKZKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYKZKCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKZKCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:02:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44818 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYKZKCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:02:20 -0500
To: tj@kernel.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com
In-reply-to: <4927BDC7.8020905@kernel.org> (message from Tejun Heo on Sat, 22
	Nov 2008 17:07:35 +0900)
Subject: Re: [PATCH 5/5 UPDATED] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org>	<1227190983-5820-6-git-send-email-tj@kernel.org> <20081121211607.49e0ec84.akpm@linux-foundation.org> <4927BC9A.3000001@kernel.org> <4927BDC7.8020905@kernel.org>
Message-Id: <E1L5HDg-0001Ty-1u@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Nov 2008 11:02:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Apologies for the late review.

On Sat, 22 Nov 2008, Tejun Heo wrote:
> + * cuse_conn	: contains fuse_conn and serves as bonding structure
> + * channel	: file handle connected to the userland CUSE server
> + * cdev		: the implemented character device
> + * mnt		: vfsmount which serves dentry and inode for cdev

Hmm, this mount thing seems rather pointless to me.  I understand the
motivation: to let the unmodified fuse functions use
get_fuse_conn(inode) and get_node_id(inode).  But I think we should
really bite the bullet and reimplement these functions so that they
take fuse_conn and node_id as arguments instead of the inode (and
separate out those parts which do really need the inode for the
memory mappings).

It's a bit more work on the fuse side, but overall it results in a
much cleaner architecture, don't you think?

> +	worker = kthread_run(cuse_init_worker, cuse_conn_get(cc),
> +			     "cuse-init-pid%d", current->pid);

This could be done without a kthread, by setting the ->end() callback
for the INIT request, no?

Thanks,
Miklos
