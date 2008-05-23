Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYEWJUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYEWJUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYEWJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:20:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbYEWJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:20:03 -0400
Date: Fri, 23 May 2008 05:20:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [patch 05/14] hpfs: dont call permission()
Message-ID: <20080523092002.GC27119@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171548.148636128@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521171548.148636128@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 07:15:03PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> hpfs_unlink() calls permission() prior to truncating the file.  HPFS
> doesn't define a .permission method, so replace with explicit call to
> generic_permission().
> 
> This is equivalent, except that devcgroup_inode_permission() and
> security_inode_permission() are not called.
> 
> The truncation is just an implementation detail of the unlink, so
> these security checks are unnecessary.
> 
> I suspect that even calling generic_permission() is unnecessary, since
> we shouldn't mind if the file isn't writable.  But I leave that to the
> maintainer to decide.

Okay to me but rather pointless.  And I agree to the last stance that
the whole logic in hpfs_unlink really needs sorting out by someone who
understands that filesystem.

