Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXE3SDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXE3SDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXE3SDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:03:15 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40779 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbXE3SDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:03:14 -0400
Date: Wed, 30 May 2007 14:03:09 -0400
To: David Howells <dhowells@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking [try #2]
Message-ID: <20070530180309.GG7736@fieldses.org>
References: <20070529215736.GO6815@fieldses.org> <20070529145426.19366.35289.stgit@warthog.cambridge.redhat.com> <32087.1180514132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32087.1180514132@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:35:32AM +0100, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > --without having tried to understand how they're actually used, these
> > data structures (like the pending_locks and granted_locks lists) seem to
> > duplicate stuff that's already kept in fs/locks.c.  Is there a reason
> > they're required?
> 
> Yes.  I need to get the server lock first, before going to the VFS locking
> routines.

That doesn't really answer the question.  The NFS client has similar
requirements, but it doesn't have to duplicate the per-inode lists of
granted locks, for example.

> The VFS routines as they stand aren't particularly useful, and they
> permit things that AFS doesn't support (such as lock upgrading).

Sure.  But handling those things is just a matter of checking for a few
special cases and making sure they're rejected before calling the posix
routines.

--b.
