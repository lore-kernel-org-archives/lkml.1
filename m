Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZGULKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZGULKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZGULKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:10:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58676 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGULKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:10:23 -0400
Date: Tue, 21 Jul 2009 16:40:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
Message-ID: <20090721111019.GV24157@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiaotian Feng <dfeng@redhat.com> [2009-07-21 18:25:26]:

> In cgroup_get_sb, the lock sequence is:
> 	mutex_lock(&inode->i_mutex);
> 	mutex_lock(&cgroup->mutex);
> so the last unlock sequence should be:
> 	mutex_unlock(&cgroup->mutex);
> 	mutex_unlock(&inode->i_mutex);
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  kernel/cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3737a68..11ef162 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  		BUG_ON(root->number_of_cgroups != 1);
> 
>  		cgroup_populate_dir(root_cgrp);
> -		mutex_unlock(&inode->i_mutex);
>  		mutex_unlock(&cgroup_mutex);
> +		mutex_unlock(&inode->i_mutex);
>  	}
>

Seems reasonable to me. You might also want to mention that elsewhere
the sequence is unlock cgroup_mutex followed by inode->i_mutex.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
 
-- 
	Balbir
