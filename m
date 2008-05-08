Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbYEHSvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbYEHSvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763958AbYEHSvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:51:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60662 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923AbYEHSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:51:22 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp,
       sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com
In-reply-to: <20080508165724.GD13914@infradead.org> (message from Christoph
	Hellwig on Thu, 8 May 2008 12:57:24 -0400)
Subject: Re: [patch 07/24] fat: dont call notify_change
References: <20080506091327.259950960@szeredi.hu> <20080506091414.440652004@szeredi.hu> <20080508165724.GD13914@infradead.org>
Message-Id: <E1JuBCt-0008E1-4E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 May 2008 20:51:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> have the full security check for it.

Yes, I'm a bit uncertain about this.  It's a user action that triggers
the mode change.  On the other hand it's just a side effect of the
ioctl.  I can re-add the security check just to be on the safe side,
but probably nobody cares.

Miklos
