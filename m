Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXE2V5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXE2V5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXE2V5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:57:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43167 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXE2V5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:57:39 -0400
Date: Tue, 29 May 2007 17:57:36 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking [try #2]
Message-ID: <20070529215736.GO6815@fieldses.org>
References: <20070529145426.19366.35289.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529145426.19366.35289.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more vague question I had while skimming the previous version--

On Tue, May 29, 2007 at 03:54:27PM +0100, David Howells wrote:
> +static void afs_grant_locks(struct afs_vnode *vnode, struct file_lock *fl)
> +{
> +	struct file_lock *p, *_p;
> +
> +	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
> +	if (fl->fl_type == F_RDLCK) {
> +		list_for_each_entry_safe(p, _p, &vnode->pending_locks,
> +					 fl_u.afs.link) {
> +			if (p->fl_type == F_RDLCK) {
> +				p->fl_u.afs.state = AFS_LOCK_GRANTED;
> +				list_move_tail(&p->fl_u.afs.link,
> +					       &vnode->granted_locks);
> +				wake_up(&p->fl_wait);
> +			}
> +		}
> +	}
> +}

--without having tried to understand how they're actually used, these
data structures (like the pending_locks and granted_locks lists) seem to
duplicate stuff that's already kept in fs/locks.c.  Is there a reason
they're required?

--b.
