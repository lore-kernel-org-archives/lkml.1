Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXJYSch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXJYSch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbXJYScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:32:11 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55228 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbXJYScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:32:08 -0400
Date: Thu, 25 Oct 2007 19:23:46 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org,
       neilb@suse.de
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-Reply-To: <200710251644.l9PGilSK021536@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0710251913150.21612@blonde.wat.veritas.com>
References: <200710251644.l9PGilSK021536@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Erez Zadok wrote:
> 
> On a related note, I would just love to get rid of calling the lower
> ->writepage in unionfs b/c I can't even tell if I have a lower page to use
> all the time.  I'd prefer to call vfs_write() if I can, but I'll need a
> struct file, or at least a dentry.

Why do you want to do that?  You gave a good reason why it's easier
for ecryptfs, but I doubt it's robust.  The higher the level you
choose to use, the harder to guarantee it won't deadlock.

Or that's my gut feeling anyway.  It's several years since I've
thought about such issues: just because I came into this knowing
about shmem_writepage, is perhaps not a good reason to choose me
as advisor!

Hugh
