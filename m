Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXEZXzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXEZXzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbXEZXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:55:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbXEZXzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:55:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070526022342.GA20905@fieldses.org>
References: <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Sun, 27 May 2007 00:55:30 +0100
Message-ID: <7436.1180223730@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > +	if (!afs_lock_manager) {
> > +		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
> > +		if (!afs_lock_manager)
> > +			return -ENOMEM;
> > +	}
> > +	return 0;
> 
> Doesn't this need some locking?

Oops.  Yes.  It used to be inside the lock_kernel() section, but has since
escaped.

> Do you allow upgrades and downgrades?  (Just curious.)

AFS does not, as far as I know.  Upgrades are dangerous anyway as you can get
deadlock quite easily.

> > +		/* if we've already got a readlock on the server and no waiting
> > +		 * writelocks, then we might be able to instantly grant another
> 
> Is that comment correct?  (You don't really test for "waiting
> writelocks", do you?)

Locally, yes.  'if (list_empty(&vnode->pending_locks))' covers it quite
handily.  I can't do anything about checking the server.

David
