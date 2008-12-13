Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYLMCy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYLMCy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLMCyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:54:19 -0500
Received: from kandzendo.ru ([195.178.208.66]:43616 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYLMCyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:54:19 -0500
Date: Sat, 13 Dec 2008 05:54:17 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 05/14] fsnotify: unified filesystem notification backend
Message-ID: <20081213025417.GC807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215140.27112.67859.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212215140.27112.67859.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Dec 12, 2008 at 04:51:40PM -0500, Eric Paris (eparis@redhat.com) wrote:
> +DEFINE_MUTEX(fsnotify_grp_mutex);
> +struct srcu_struct fsnotify_grp_srcu_struct;
> +LIST_HEAD(fsnotify_groups);
> +__u64 fsnotify_mask;

Those can be static.

> +struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
> +{
> +	struct fsnotify_event *event;
> +
> +	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
> +	if (!event)
> +		return NULL;
> +
> +	atomic_set(&event->refcnt, 1);
> +
> +	spin_lock_init(&event->lock);
> +
> +	event->path.dentry = NULL;
> +	event->path.mnt = NULL;
> +	event->inode = NULL;
> +
> +	INIT_LIST_HEAD(&event->private_data_list);
> +
> +	event->to_tell = to_tell;

What prevents this inode to be released?

-- 
	Evgeniy Polyakov
