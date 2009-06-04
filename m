Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZFDRLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZFDRLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZFDRLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:11:46 -0400
Received: from thunk.org ([69.25.196.29]:47681 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZFDRLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:11:45 -0400
Date: Thu, 4 Jun 2009 13:11:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Message-ID: <20090604171142.GB13639@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <20090527142332.GB10842@mit.edu> <20090527145911.GH16006@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527145911.GH16006@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:59:11PM +0200, Jan Kara wrote:
>   Yes, that would be fine. Thanks. Luckily, the dependence is just one way
> (ext4 change has to go after the VFS patch) so it's just enough to merge
> that ext4 change some time after VFS changes go in.

ext4: Add WARN_ON on unmapped dirty buffer_heads in writepage
fs: Don't clear dirty bits in block_write_full_page()
vfs: Unmap underlying metadata of new data buffers only when buffer is m
ext4: Make sure blocks are properly allocated under mmaped page even whe
vfs: Add better VFS support for page_mkwrite when blocksize < pagesize

FYI, I've added the following to the unstable portion of the patch
queue, and have started running tests (fsx, fsstress, and dbench)
using 1k blocksizes, using a variety of ext4 mount options.  So far,
things look good.

How goes the reviews/comments?  Are we planning on pushing this to
Linus at the beginning of the next merge window?

      	     	       	      	   	 - Ted
