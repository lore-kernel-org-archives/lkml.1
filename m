Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbYF2MC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbYF2MC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYF2MCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:02:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46036 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYF2MCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:02:15 -0400
Date: Sun, 29 Jun 2008 12:56:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Christoph Hellwig <hch@infradead.org>
cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       mhalcrow@us.ibm.com, hooanon05@yahoo.co.jp, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking
In-Reply-To: <20080629071528.GA31114@infradead.org>
Message-ID: <Pine.LNX.4.64.0806291244440.32708@blonde.site>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
 <20080629071528.GA31114@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Christoph Hellwig wrote:
> 
> Btw, I hope fsstack doesn't rely on i_size having any particular
> meaning.  As far as the VFS is concerned i_size is field only used by
> the filesystem (or library routines like generic_file_*).

Interesting point.  I can't speak for fsstack itself (I'm not even
sure if it's anything beyond fs/stack.c and the tag I used to identify
where this patch lies); but certainly fs/stack.c doesn't use i_size
for anything, just duplicates it from the lower filesystem.

unionfs (which I think you don't care for at all in general) does
look as if it assumes it's the lower file size in a few places,
when copying up or truncating.  Isn't that reasonable?  Wouldn't
users make the same assumption?

Or are you saying that filesystems which don't support the usual
meaning of inode->i_size (leave it 0?) would supply their own
equivalent to vmtruncate() if they support truncation, and their
own getattr which fills in stat->size from somewhere else.

Yes, I think you are saying that: unionfs may not play well with them.

Hugh
