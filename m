Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZCWLEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZCWLEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZCWLEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:04:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZCWLEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:04:32 -0400
Date: Mon, 23 Mar 2009 11:04:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 10/13] fsnotify: allow groups to add private data to
	events
Message-ID: <20090323110429.GQ28946@ZenIV.linux.org.uk>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com> <20090319180547.17449.9496.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319180547.17449.9496.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:05:47PM -0400, Eric Paris wrote:

> -int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event)
> +int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv)
>  {
>  	struct fsnotify_event_holder *holder;
>  	struct list_head *list = &group->notification_list;
> @@ -166,6 +183,8 @@ int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event
>  
>  	fsnotify_get_event(event);
>  	list_add_tail(&holder->event_list, list);
> +	if (priv)
> +		list_add_tail(&priv->event_list, &event->private_data_list);

Won't that leak priv if we bugger off earlier?  On OOM or on finding last_event
we are OK with...
