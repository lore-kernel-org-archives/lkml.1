Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbYK1FOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYK1FOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 00:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYK1FOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 00:14:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42674 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYK1FOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 00:14:44 -0500
Date: Fri, 28 Nov 2008 05:14:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 8/8] dnotify: reimplement dnotify using fsnotify
Message-ID: <20081128051443.GH28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21:33PM -0500, Eric Paris wrote:

> +	.mark_clear_inode = clear_mark_dir_notify,

... called under a spinlock

> +static void clear_mark_dir_notify(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned long mask __attribute__ ((unused)), unsigned int flags)
> +{
...
> +	fsnotify_put_group(dnotify_group);

... which grabs a mutex.

Incidentally, why the hell do you bother with refcounting on groups here?
dnotify is not something that's going to be unloaded, for fsck sake...
