Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKZAP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKZAP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYKZAPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:15:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYKZAPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:15:47 -0500
Date: Tue, 25 Nov 2008 16:14:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 0/8] file notification: fsnotify a unified file
 notification backend
Message-Id: <20081125161435.f65d6f06.akpm@linux-foundation.org>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 12:20:51 -0500
Eric Paris <eparis@redhat.com> wrote:

> This series only reimplements dnotify using the new fsnotify backend.  If
> accepted I will do the work to port inotify as well.  Currently struct inode
> goes from:
> 
> #ifdef CONFIG_DNOTIFY
>        unsigned long           i_dnotify_mask; /* Directory notify events */
>        struct dnotify_struct   *i_dnotify; /* for directory notifications */
> #endif
> 
> to:
> #ifdef CONFIG_FSNOTIFY
>        unsigned long           i_fsnotify_mask; /* all events this inode cares about */
>        struct list_head        i_fsnotify_mark_entries; /* fsnotify mark entries */
>        spinlock_t              i_fsnotify_lock; /* protect the entries list */
> #endif
> 
> so the inode still grows, but the inotify fields will be dropped as well
> resulting in a smaller struct inode.  These are all the fields fanotify will
> want as well.

Did you consider using i_lock to protect that list?  Its mandate is "an
innermost lock which protects fields within the inode".

> 29 files changed, 3100 insertions(+), 1977 deletions(-)

	if (code > code_reviewers)
		fix();

but how?
