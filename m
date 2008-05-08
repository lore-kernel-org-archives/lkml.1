Return-Path: <linux-kernel-owner+w=401wt.eu-S1765388AbYEHRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765388AbYEHRAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765540AbYEHQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:57:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765532AbYEHQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:57:50 -0400
Date: Thu, 8 May 2008 12:57:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, sds@tycho.nsa.gov,
       jmorris@namei.org, casey@schaufler-ca.com
Subject: Re: [patch 07/24] fat: dont call notify_change
Message-ID: <20080508165724.GD13914@infradead.org>
References: <20080506091327.259950960@szeredi.hu> <20080506091414.440652004@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091414.440652004@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:34AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> the file mode before changing the inode attributes.  Replace with
> explicit call to fat_setattr().
> 
> This is equivalent, except that security_inode_setattr() is not called
> before fat_setattr().  I think this is not needed, since the mode
> change is just a side effect of the attribute change.

Actually I think we want the security_inode_setattr.  This is an
implicit chmode when switching the ATTR_RO flag on and off and we should
have the full security check for it.  Then again I'm not sure the
security modules care about this level of detail because there's
probably even worse ioctl hidden somewhere.

Ccing the Selinux guys and Casey in case they care.

