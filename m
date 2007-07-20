Return-Path: <linux-kernel-owner+w=401wt.eu-S1764490AbXGTDld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764490AbXGTDld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbXGTDlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:41:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772AbXGTDlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:41:24 -0400
Date: Thu, 19 Jul 2007 20:41:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
Message-Id: <20070719204102.7b82692d.akpm@linux-foundation.org>
In-Reply-To: <469DABA5.9070706@yahoo.com.au>
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
	<20070717175017.8b8a8976.akpm@linux-foundation.org>
	<469DABA5.9070706@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 15:56:53 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andrew Morton wrote:
> > On Tue, 17 Jul 2007 13:47:32 +0100
> > David Howells <dhowells@redhat.com> wrote:
> > 
> > 
> >>+	if (type == AFS_LOCK_READ &&
> >>+	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
> > 
> > 
> > Here we use
> > 
> > 	vnode->flags & (1 << foo)
> > 
> > 
> >>+		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
> > 
> > 
> > and elsewhere we use set_bit(foo, &vnode->flags) and clear_bit()
> > 
> > This is a bit strange.  Does the open-coded bit-test have any performance
> > benefit on any architecture?  Not on x86 at least, afaik.
> 
> It uses locked operations on x86, but you can use __set_bit instead
> (which should always be at least as efficient as the C version).

I said "bit-test".  ie: test_bit().  That doesn't use a locked operation.
