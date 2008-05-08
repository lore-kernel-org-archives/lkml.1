Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYEHQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYEHQun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbYEHQuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:50:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbYEHQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:50:16 -0400
Date: Thu, 8 May 2008 12:50:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 05/24] sysfs: dont call notify_change
Message-ID: <20080508165013.GB13914@infradead.org>
References: <20080506091327.259950960@szeredi.hu> <20080506091411.769104277@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091411.769104277@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:32AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> sysfs_chmod_file() calls notify_change() to change the permission bits
> on a sysfs file.  Replace with explicit call to sysfs_setattr() and
> fsnotify_change().
> 
> This is equivalent, except that security_inode_setattr() is not
> called.  This function is called by drivers, so the security checks do
> not make any sense.

Looks correct to me, although I really don't see the point for it.

