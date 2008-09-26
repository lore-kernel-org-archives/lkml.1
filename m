Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYIZWYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYIZWYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYIZWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:24:42 -0400
Received: from [198.145.64.141] ([198.145.64.141]:44965 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752069AbYIZWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:24:41 -0400
Date: Fri, 26 Sep 2008 15:21:47 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 3/11] fanotify: fscking all notify, system
	wide file access notification
Message-ID: <20080926222147.GC10141@kroah.com>
References: <1222463904.2872.212.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222463904.2872.212.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:18:24PM -0400, Eric Paris wrote:
> diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
> new file mode 100644
> index 0000000..d6bc0c0
> --- /dev/null
> +++ b/fs/notify/fanotify.h
> @@ -0,0 +1,87 @@
> +#ifndef _LINUX_FANOTIFY_PRIVATE_H
> +#define _LINUX_FANOTIFY_PRIVATE_H
> +
> +#include <linux/fanotify.h>
> +
> +
> +#include <asm/atomic.h>
> +#include <linux/dcache.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/path.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>

<asm/> includes after <linux/> please.

> +
> +extern int check_notification_queue(struct fanotify_group *group);
> +extern void get_event(struct fanotify_event *event);
> +extern void put_event(struct fanotify_event *event);
> +extern int add_event_to_group_notification(struct fanotify_group *group, struct fanotify_event *event);
> +extern struct fanotify_event *remove_event_from_group_notification(struct fanotify_group *group);
> +extern struct fanotify_event *create_event(struct file *file, unsigned int mask);
> +extern struct fanotify_event_holder *alloc_event_holder(void);
> +extern void destroy_event_holder(struct fanotify_event_holder *holder);

Those are some pretty generic global function names (get_event?).
Please add a fanotify_ to the front of them to help developers
understand them and to not polute the global name space.

> +extern __init int fanotify_notification_init(void);
> +extern __init int fanotify_notification_uninit(void);
> +
> +extern void fanotify_get_group(struct fanotify_group *group);
> +extern void fanotify_put_group(struct fanotify_group *group);
> +extern int fanotify_register_group(char *name, unsigned int mask);
> +extern int fanotify_unregister_group(char *name, unsigned int mask);

Like you did here nicely :)

> +DEFINE_MUTEX(groups_mutex);
> +struct srcu_struct groups_srcu_struct;
> +LIST_HEAD(groups);

Again with the generic global symbol names.

thanks,

greg k-h
