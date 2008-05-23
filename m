Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYEWJ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYEWJ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYEWJ01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:26:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYEWJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:26:27 -0400
Date: Fri, 23 May 2008 05:26:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
Message-ID: <20080523092626.GE27119@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171557.399850407@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521171557.399850407@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:15:09PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> For execute permission on a regular files we need to check if file has
> any execute bits at all, regardless of capabilites.
> 
> This check is normally performed by generic_permission() but was also
> added to the case when the filesystem defines its own ->permission()
> method.  In the latter case the filesystem should be responsible for
> performing this check.
> 
> So create a helper function exec_permission() that checks returns
> -EACCESS if MAY_EXEC is present, the inode is a regular file and no
> execute bits are present in inode->i_mode.
> 
> Call this function from filesystems which don't call
> generic_permission() from their ->permission() methods and which
> aren't already performing this check.  Also remove the check from
> dentry_permission().
> 
> The new code should be equivalent to the old.

There's no point moving this into the filesystem.

