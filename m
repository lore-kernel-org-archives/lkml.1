Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZFDOKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZFDOKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZFDOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:09:53 -0400
Received: from thunk.org ([69.25.196.29]:57702 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZFDOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:09:53 -0400
Date: Thu, 4 Jun 2009 10:09:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 05/11] ext4: Make sure blocks are properly allocated
	under mmaped page even when blocksize < pagesize
Message-ID: <20090604140949.GA2542@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-6-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243429268-3028-6-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:01:02PM +0200, Jan Kara wrote:
> In a situation like:
>   truncate(f, 1024);
>   a = mmap(f, 0, 4096);
>   a[0] = 'a';
>   truncate(f, 4096);
> 
> we end up with a dirty page which does not have all blocks allocated /
> reserved.  Fix the problem by using new VFS infrastructure.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

One warning --- this patch will have a slight patch conflict with the
patch ext4-convert-markers-to-tracepoints in the ext4 patch queue.

The ext4-convert-markers-to-tracepoints patch is also in the unstable
part of the patch queue, since it is waiting for patches allowing
tracepoints to be used in modules to be merged into mainline at the
next merge window.  It's a very minor, easy fix-up, but depending who
which patch series gets merged first, there might be a minor fixup
required.

						- Ted
