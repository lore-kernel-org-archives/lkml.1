Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXJYQtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXJYQtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762893AbXJYQpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:45:18 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35007 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762945AbXJYQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:45:15 -0400
Date: Thu, 25 Oct 2007 12:44:47 -0400
Message-Id: <200710251644.l9PGilSK021536@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Erez Zadok <ezk@cs.sunysb.edu>,
       Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org,
       neilb@suse.de
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-reply-to: Your message of "Thu, 25 Oct 2007 16:36:44 BST."
             <Pine.LNX.4.64.0710251556300.1521@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That's a nice historical review, Huge, of how got into these mess we're in
now -- it all starts with good intentions. :-)

On a related note, I would just love to get rid of calling the lower
->writepage in unionfs b/c I can't even tell if I have a lower page to use
all the time.  I'd prefer to call vfs_write() if I can, but I'll need a
struct file, or at least a dentry.

What ecryptfs does is store a struct file inside it's inode, so it can use
it later in ->writepage to call vfs_write on the lower f/s.  And Unionfs may
have to go in that direction too, but this trick is not terribly clean --
storing a file inside an inode.

I realize that the calling path to ->writepage doesn't have a file/dentry
any more, but if we're considering larger changes to the writepage related
code, can we perhaps consider passing a file or dentry to >writepage (same
as commit_write, perhaps).

Thanks,
Erez.
