Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbXE0IvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbXE0IvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 04:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXE0IvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 04:51:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0IvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 04:51:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070527022502.GB10867@fieldses.org>
References: <20070527022502.GB10867@fieldses.org> <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Sun, 27 May 2007 09:51:10 +0100
Message-ID: <18750.1180255870@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > > Do you allow upgrades and downgrades?  (Just curious.)
> > 
> > AFS does not, as far as I know.
> 
> So if I request a write lock while holding a read lock, my request will
> be denied?

At the moment, yes.  Don't the POSIX and flock lock-handling routines in the
kernel normally do that anyway?

> This is a little strange, though--if there's somebody waiting for a
> write lock on an inode (because somebody else already holds a read lock
> on it), that shouldn't block requests for read locks.

That depends on whether you want fairness or not.  Allowing read locks to jump
the queue like this can lead to starvation for your writers.

David
