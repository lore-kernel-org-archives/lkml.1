Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbXEIKmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbXEIKmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEIKlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:41:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbXEIKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:41:45 -0400
Date: Wed, 9 May 2007 03:41:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] AFS: Implement basic file write support
Message-Id: <20070509034135.853ae84c.akpm@linux-foundation.org>
In-Reply-To: <997.1178706347@redhat.com>
References: <20070508170051.eb4751ce.akpm@linux-foundation.org>
	<20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com>
	<20070508194411.27477.7552.stgit@warthog.cambridge.redhat.com>
	<997.1178706347@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 11:25:47 +0100 David Howells <dhowells@redhat.com> wrote:

> > > +	set_page_dirty(page);
> > > +
> > > +	if (PageDirty(page))
> > > +		_debug("dirtied");
> > > +
> > > +	return 0;
> > > +}
> > 
> > One would normally run mark_inode_dirty() after any i_size_write()?
> 
> Not in this case, I assume, because set_page_dirty() ultimately calls
> __mark_inode_dirty(), but I could be wrong.

set_page_dirty() will set I_DIRTY_PAGES only.  ie: the inode has dirty
pagecache data.

To tell the VFS that the inode itself is dirty one needs to run
mark_inode_dirty().  Or maybe mark_inode_dirty_sync() but I can never for
the life of me remember what that thing does.

