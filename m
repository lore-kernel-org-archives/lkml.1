Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYEWJws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYEWJws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYEWJwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:52:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39897 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYEWJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:52:39 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <20080523092626.GE27119@infradead.org> (message from Christoph
	Hellwig on Fri, 23 May 2008 05:26:26 -0400)
Subject: Re: [patch 11/14] vfs: move executable checking into ->permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171557.399850407@szeredi.hu> <20080523092626.GE27119@infradead.org>
Message-Id: <E1JzTwx-0001bw-DT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 11:52:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > For execute permission on a regular files we need to check if file has
> > any execute bits at all, regardless of capabilites.
> > 
> > This check is normally performed by generic_permission() but was also
> > added to the case when the filesystem defines its own ->permission()
> > method.  In the latter case the filesystem should be responsible for
> > performing this check.
> > 
> > So create a helper function exec_permission() that checks returns
> > -EACCESS if MAY_EXEC is present, the inode is a regular file and no
> > execute bits are present in inode->i_mode.
> > 
> > Call this function from filesystems which don't call
> > generic_permission() from their ->permission() methods and which
> > aren't already performing this check.  Also remove the check from
> > dentry_permission().
> > 
> > The new code should be equivalent to the old.
> 
> There's no point moving this into the filesystem.

Yes, there is.  Fuse already has special code, because it need to
refresh the attributes first before doing the "are there any x bits in
mode?" check.  And because there's some duplication, I've introduced a
helper.  That's exactly how we handle this sort of thing.

Miklos
