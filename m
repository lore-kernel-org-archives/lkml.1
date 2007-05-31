Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbXEaJmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbXEaJmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbXEaJl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:41:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858AbXEaJl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:41:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070530180309.GG7736@fieldses.org>
References: <20070530180309.GG7736@fieldses.org> <20070529215736.GO6815@fieldses.org> <20070529145426.19366.35289.stgit@warthog.cambridge.redhat.com> <32087.1180514132@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking [try #2]
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 31 May 2007 10:41:37 +0100
Message-ID: <24732.1180604497@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> > Yes.  I need to get the server lock first, before going to the VFS locking
> > routines.
> 
> That doesn't really answer the question.  The NFS client has similar
> requirements, but it doesn't have to duplicate the per-inode lists of
> granted locks, for example.

Actually, it might...  It's just that they're in the lock manager server, not
in the NFS client.

As far as I can tell, NFS passes each lock request individually to the lock
manager server, which grants them individually.  AFS doesn't do that.

David
