Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYK0QPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYK0QPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYK0QPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:15:08 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:63731 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYK0QPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:15:07 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
 backend
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 17:14:31 +0100
Message-Id: <1227802471.4454.1754.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> +
> +void fsnotify_put_group(struct fsnotify_group *group)
> +{
> +       mutex_lock(&fsnotify_grp_mutex);
> +       if (atomic_dec_and_test(&group->refcnt)) {
> +               list_del_rcu(&group->group_list);
> +               mutex_unlock(&fsnotify_grp_mutex);
> +
> +               synchronize_srcu(&fsnotify_grp_srcu_struct);
> +
> +               fsnotify_recalc_global_mask();
> +               fsnotify_kill_group(group);
> +
> +               return;
> +       }
> +       mutex_unlock(&fsnotify_grp_mutex);
> +
> +       return;
> +}

do you really need that mutex in the ! case?

