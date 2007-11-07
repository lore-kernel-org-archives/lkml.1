Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbXKGObe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbXKGObe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758775AbXKGObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:31:19 -0500
Received: from host-66-43-248-10 ([67.55.143.10]:58328 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758722AbXKGObS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:31:18 -0500
Subject: Re: [Unionfs] Re: [PATCH] IGET: Stop UnionFS from using iget() and
	read_inode()
From: Paul Albrecht <albrecht@rdi1.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org
In-Reply-To: <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu>
References: <200711070644.lA76iodZ005491@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Nov 2007 08:31:51 -0600
Message-Id: <1194445911.2705.2.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 01:44 -0500, Erez Zadok wrote:
> In message <20071106145234.4807.69325.stgit@warthog.procyon.org.uk>, David Howells writes:
> > From: David Howells <dhowells@redhat.com>
> > 
> > Stop the UnionFS filesystem from using iget() and read_inode().  Replace
> > unionfs_read_inode() with unionfs_iget(), and call that instead of iget().
> > unionfs_iget() then uses iget_locked() directly and returns a proper error code
> > instead of an inode in the event of an error.
> > 
> > unionfs_fill_super() returns any error incurred when getting the root inode
> > instead of EINVAL.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> [...]
> 
> Thanks.  I tested this code and it passed all my tests.  I'll shortly submit
> a slightly revised patch which applies cleanly against the unionfs code in
> -mm.

Does your test set include readahead-list? I can't get it to work with a
union mounted filesystem without segfault'ing and kernel oops'ing.

Paul Albrecht
