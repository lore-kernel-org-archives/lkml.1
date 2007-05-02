Return-Path: <linux-kernel-owner+w=401wt.eu-S1766751AbXEBTfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766751AbXEBTfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766763AbXEBTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:35:12 -0400
Received: from THUNK.ORG ([69.25.196.29]:51025 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766751AbXEBTfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:35:07 -0400
Date: Wed, 2 May 2007 15:34:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org, tridge@samba.com
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502193456.GE19442@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeremy Allison <jra@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Cabot, Mason B" <mason.b.cabot@intel.com>,
	linux-kernel@vger.kernel.org, tridge@samba.com
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070501142325.09c294bd.akpm@linux-foundation.org> <20070502161638.GB19442@thunk.org> <20070502180810.GC28726@jeremy-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502180810.GC28726@jeremy-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:08:10AM -0700, Jeremy Allison wrote:
> > The right place is clearly Samba.  I can't think of any other program
> > or filesystem protocol where writing a 1 byte write at 128k strides
> > would be used to signal a desire to do preallocation.  In fact, it's
> > hard to think of a worse way of doing things.
> 
> In fact they don't need to do this - there's an explicit CIFS
> set file allocation call to pre-allocate size they could use.
> 
> There's a specific Samba VFS module that has XFS specific calls
> to do this - vfs_prealloc. - but this won't work on ext3.

Jeremy,

	FYI, we are currently closing on a new system call so that
glibc's fallocate() will be able to call into the appropriate
per-filesystem routines in a portable way, since ext4 will have
persistent preallocation support.

	I think we mostly have consensus on a calling convention which
all of the architectures (s390, power, arm, ia64, etc.); of course
then we will need to get glibc to support the new system call.

						- Ted

