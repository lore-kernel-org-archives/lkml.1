Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYCSVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYCSVUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762036AbYCSUAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762027AbYCSUAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:10 -0400
Date: Wed, 19 Mar 2008 11:16:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6] vfs: pnode cleanup
Message-ID: <20080319111608.GI10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212733.921047238@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313212733.921047238@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:26:43PM +0100, Miklos Szeredi wrote:
> Move set_mnt_shared from pnode.h to pnode.c.  Change
> CLEAR_MNT_SHARED() to clear_mnt_shared() function, and move to
> pnode.c.

I don't see why these two are a cleanup, actually.

> @@ -89,20 +100,18 @@ static int do_make_slave(struct vfsmount
>  		list_for_each_entry(slave_mnt, &mnt->mnt_slave_list, mnt_slave)
>  			slave_mnt->mnt_master = master;
>  		list_move(&mnt->mnt_slave, &master->mnt_slave_list);
> -		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
> -		INIT_LIST_HEAD(&mnt->mnt_slave_list);
> +		list_splice_init(&mnt->mnt_slave_list,
> +				 master->mnt_slave_list.prev);

Umm...  OK.

>  	} else {
> -		struct list_head *p = &mnt->mnt_slave_list;
> -		while (!list_empty(p)) {
> -                        slave_mnt = list_first_entry(p,
> +		while (!list_empty(&mnt->mnt_slave_list)) {
> +			slave_mnt = list_first_entry(&mnt->mnt_slave_list,

How is that better?


> -	INIT_LIST_HEAD(&mnt->mnt_slave_list);

Fine by me.
