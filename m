Return-Path: <linux-kernel-owner+w=401wt.eu-S934109AbYF3VyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbYF3VyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933726AbYF3Vq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:46:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44555 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806AbYF3VqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:46:25 -0400
Date: Mon, 30 Jun 2008 16:49:01 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, hooanon05@yahoo.co.jp,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking
Message-ID: <20080630214901.GA8900@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <Pine.LNX.4.64.0806291244440.32708@blonde.site> <200806301819.m5UIJRhv030310@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806301819.m5UIJRhv030310@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:19:27PM -0400, Erez Zadok wrote:
> BTW, ecryptfs may have a problem with this, b/c it uses
> i_size_read/write b/t the lower and upper inodes.  If some
> filesystems have a different interpretation for i_size, then
> stacking ecryptfs on top of them could be an issue.  Mike?

eCryptfs depends on the results of i_size_read() on the lower inode
when it needs to interpolate the filesize when the metadata is stored
in the lower file's xattr region.
