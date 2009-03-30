Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZC3Rqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZC3Rqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZC3RqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:46:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:49939 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbZC3RqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:46:17 -0400
Date: Mon, 30 Mar 2009 13:46:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Message-ID: <20090330174607.GR13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu> <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238413667.30488.2.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 07:47:47AM -0400, Chris Mason wrote:
> > Yes, it was.  Although I got the idea when hch pointed out that SuSE did
> > this... thanks to Chris.  It's come full circle.  :)
> 
> Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
> commit is required though.  I think the inode could be clean but still
> have metadata that needs commit.

So to close this hole, I think what we can do is to track the last
transaction id where ext4_do_update_inode() was called, and if that
transaction id == the currently running transaction id, then we need
to call ext4_force_commit() even though the inode is clean.  I think
that should fix up the race that you're concerned about.

     	    	       	    	 		  - Ted
