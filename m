Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYEHXq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYEHXq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYEHXqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:46:09 -0400
Received: from namei.org ([69.55.235.186]:48189 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753740AbYEHXqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:46:07 -0400
Date: Fri, 9 May 2008 09:45:02 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Christoph Hellwig <hch@infradead.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com
Subject: Re: [patch 07/24] fat: dont call notify_change
In-Reply-To: <20080508165724.GD13914@infradead.org>
Message-ID: <Xine.LNX.4.64.0805090937550.24909@us.intercode.com.au>
References: <20080506091327.259950960@szeredi.hu> <20080506091414.440652004@szeredi.hu>
 <20080508165724.GD13914@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Christoph Hellwig wrote:

> On Tue, May 06, 2008 at 11:13:34AM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> > the file mode before changing the inode attributes.  Replace with
> > explicit call to fat_setattr().
> > 
> > This is equivalent, except that security_inode_setattr() is not called
> > before fat_setattr().  I think this is not needed, since the mode
> > change is just a side effect of the attribute change.
> 
> Actually I think we want the security_inode_setattr.  This is an
> implicit chmode when switching the ATTR_RO flag on and off and we should
> have the full security check for it.  Then again I'm not sure the
> security modules care about this level of detail because there's
> probably even worse ioctl hidden somewhere.
> 
> Ccing the Selinux guys and Casey in case they care.
> 

I don't know of any situation where we'd have policy differentating the 
ioctl check from setattr for FAT (or any filesystem).


- James
-- 
James Morris
<jmorris@namei.org>
