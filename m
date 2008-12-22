Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYLVNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYLVNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYLVNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:43:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYLVNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:43:03 -0500
Date: Mon, 22 Dec 2008 13:43:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 07/14] fsnotify: add in inode fsnotify markings
Message-ID: <20081222134300.GA21807@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215151.27112.71399.stgit@paris.rdu.redhat.com> <20081213030701.GD807@ioremap.net> <1229186110.29167.100.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229186110.29167.100.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:35:09AM -0500, Eric Paris wrote:

> So to find an entry we need to first grab the inode->i_lock and start to
> walk the inode->i_fsnotify_mark_entries list.  Since we hold the i_lock
> we are not allowed to grab any other locks nor are we allowed to change
> anything other than entry->i_list.  The secret sauce is that we actually
> move the entry from the inode list to a private list which we can walk
> and modify lockless.  Inside the event we actually have to use a
> different list, free_i_list, for this operation so nothing else that
> races with us can mess stuff up.  We run the entire inode we are trying
> to free all entries for an put the entries on the private list.  We do
> NOT modify event->inode.

And just what happens if #3 ("remove entry") hits us in the meanwhile?  Freed
object sitting on free_i_list?
