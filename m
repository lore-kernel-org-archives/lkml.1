Return-Path: <linux-kernel-owner+w=401wt.eu-S933636AbXEFLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbXEFLOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbXEFLOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:14:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbXEFLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:14:17 -0400
Date: Sun, 6 May 2007 12:14:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/4] fs: Introduce path_component_lookup
Message-ID: <20070506111412.GC1211@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu> <11784065742752-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784065742752-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote up the suggestion before my first morning tea yesterday
and must admit that the name path_component_lookup is pretty stupid.
We don't just look up a component but any relative path starting
from the vfsmount/dentry pair.  How about vfs_path_lookup instead
because it mirrors various other vfs_ function that are dentry based?

Also as a new exported symbol it should get a kerneldoc comment describing
it.

> +	if (likely(retval == 0)) {
> +		if (unlikely(!audit_dummy_context() && nd && nd->dentry && 
> +				nd->dentry->d_inode))
> +			audit_inode(name, nd->dentry->d_inode);
> +	}

This should get the same simplification I suggested for do_path_lookup.

