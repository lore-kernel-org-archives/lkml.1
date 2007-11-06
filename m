Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXKFK0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXKFK0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXKFKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:25:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbXKFKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:25:52 -0500
Date: Tue, 6 Nov 2007 02:25:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/31] IGET: Stop FreeVXFS from using iget() and
 read_inode() [try #5]
Message-Id: <20071106022505.f32b1bff.akpm@linux-foundation.org>
In-Reply-To: <20071025163514.5057.4558.stgit@warthog.procyon.org.uk>
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk>
	<20071025163514.5057.4558.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 17:35:14 +0100 David Howells <dhowells@redhat.com> wrote:

> Stop the FreeVXFS filesystem from using iget() and read_inode().  Replace
> vxfs_read_inode() with vxfs_iget(), and call that instead of iget().
> vxfs_iget() then uses iget_locked() directly and returns a proper error code
> instead of an inode in the event of an error.
> 
> vxfs_fill_super() returns any error incurred when getting the root inode
> instead of EINVAL.

alpha:

fs/freevxfs/vxfs_inode.c:298: error: conflicting types for 'vxfs_iget'
fs/freevxfs/vxfs_extern.h:61: error: previous declaration of 'vxfs_iget' was here

Not completely trivial - the ino_t -> unsigned long conversion needs to be
propagated fairly widely in there.

(when should we be using ino_t and when should we be using unsigned long,
anyway?)
