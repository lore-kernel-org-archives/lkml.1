Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYE2MrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYE2MrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYE2MrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:47:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYE2MrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:47:04 -0400
Date: Thu, 29 May 2008 08:47:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>, NeilBrown <neilb@suse.de>
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
Message-ID: <20080529124701.GA13147@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113312.288347247@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:49PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Rename nfsd specific MAY_* flags to NFSD_MAY_* to make it clear, that
> these are not used outside nfsd, and to avoid namespace conflicts with
> the VFS.

But they _are_ in the same namespace as the VFS ones.  This needs to be
sorted out by real by understanding what's going on here and either
separating this flags out and passing them in a separate argument, or
moving them to include/linux/fs.h so it's obvious for anyone adding new
flags that they must not collide.  In that later case it might make
sense to add add a NFSD in the name, although MAY_NFSD_* makes more
sense to keep a unique prefix.

