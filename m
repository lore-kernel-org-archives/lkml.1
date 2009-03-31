Return-Path: <linux-kernel-owner+w=401wt.eu-S1763991AbZCaSvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763991AbZCaSvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763356AbZCaSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:44:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763304AbZCaSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:44:12 -0400
Date: Tue, 31 Mar 2009 14:44:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 18/35 xattr-rework] reiserfs: Clean up xattrs when
	REISERFS_FS_XATTR is unset
Message-ID: <20090331184402.GA28520@infradead.org>
References: <20090330180215.951354436@suse.com> <20090330181011.592648722@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330181011.592648722@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:02:33PM -0400, Jeff Mahoney wrote:
>  The current reiserfs xattr implementation will not clean up old xattr
>  files if files are deleted when REISERFS_FS_XATTR is unset. This results
>  in inaccessible lost files, wasting space.
> 
>  This patch compiles in basic xattr knowledge, such as how to delete them and
>  change ownership for quota tracking. If the file system has never used
>  xattrs, then the operation is quite fast: it returns immediately when
>  it sees there is no .reiserfs_priv directory.

What about just making xattr suppose unconditional?  That's what most
never filesystems do, and it really shouldn't be a whole lot of code.

