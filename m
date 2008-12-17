Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753455AbYLQXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYLQXIh (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYLQXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbYLQXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:08:27 -0500
Date: Wed, 17 Dec 2008 15:06:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, ttb@tentacle.dhs.org,
        rml@novell.com, kosaki.motohiro@jp.fujitsu.com, zbr@ioremap.net,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] filesystem notification: create fs/notify to contain
 all fs notification
Message-Id: <20081217150613.bf787435.akpm@linux-foundation.org>
In-Reply-To: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
References: <20081217185941.2188.49536.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 13:59:41 -0500
Eric Paris <eparis@redhat.com> wrote:

> Creating a generic filesystem notification interface, fsnotify, which will be
> used by inotify, dnotify, and eventually fanotify is really starting to
> clutter the fs directory.  This patch simply moves inotify and dnotify into
> fs/notify/inotify and fs/notify/dnotify respectively to make both current fs/
> and future notification tidier.
> 

I have no objections.

> ---
> 
>  fs/Kconfig                       |   39 --
>  fs/Makefile                      |    5 
>  fs/dnotify.c                     |  194 --------
>  fs/inotify.c                     |  913 --------------------------------------
>  fs/inotify_user.c                |  778 --------------------------------
>  fs/notify/Kconfig                |    2 
>  fs/notify/Makefile               |    2 
>  fs/notify/dnotify/Kconfig        |   10 
>  fs/notify/dnotify/Makefile       |    1 
>  fs/notify/dnotify/dnotify.c      |  194 ++++++++
>  fs/notify/inotify/Kconfig        |   27 +
>  fs/notify/inotify/Makefile       |    2 
>  fs/notify/inotify/inotify.c      |  913 ++++++++++++++++++++++++++++++++++++++
>  fs/notify/inotify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++
>  14 files changed, 1931 insertions(+), 1927 deletions(-)

But I don't want to carry the patch in -mm - I'm not well set up for
large file movement patches and they're a pita to carry.

git does a good job of this and perhaps we can persuade Al to carry
this patch in the vfs tree.  Otherwise I'd suggest that you send it in
to Linus lateish in the 2.6.29-rc1 merge window.  Please remember to cc
me on that email.
