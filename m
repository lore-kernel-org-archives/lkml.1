Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXJ1OOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXJ1OOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXJ1OOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:14:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXJ1OOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:14:41 -0400
Date: Sun, 28 Oct 2007 14:14:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] VFS: swap do_ioctl and vfs_ioctl names
Message-ID: <20071028141434.GB29323@infradead.org>
References: <11935266454097-git-send-email-ezk@cs.sunysb.edu> <11935266453628-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11935266453628-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 07:10:44PM -0400, Erez Zadok wrote:
> Rename old vfs_ioctl to do_ioctl, because the comment above it clearly
> indicates that it is an internal function not to be exported to modules;
> therefore it should have a more traditional do_XXX name.  The new do_ioctl
> is exported in fs.h but not to modules.
> 
> Rename the old do_ioctl to vfs_ioctl because the names vfs_XXX should
> preferably be reserved to callable VFS functions which modules may call,
> as many other vfs_XXX functions already do.

Yes, good idea for consistency.

> Export the new vfs_ioctl to
> modules so others can use it (including Unionfs and eCryptfs).

> +EXPORT_SYMBOL(vfs_ioctl);

This should be an _GPL export.  All new exports for above VFS users
like NFSD or stackable filesystem are _GPL because they're not for
general consumptions but these rather specific tied to the kernel
uses.

And while you're at it I'd suggest adding a docbook comment describing
the new export vfs_ioctl because we'd eventually like to have the exported
API documented fully.
