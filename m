Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYFCN4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYFCN4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYFCNzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:55:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50234 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbYFCNzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:55:55 -0400
X-Sasl-enc: 8+4nHJXkguh0pYs6uBaFNal1qZ93GCFoZ4vP61LvcdGM 1212500059
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603104814.GU28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <E1K3Ttv-0005ji-Cx@pomaz-ex.szeredi.hu>
	 <20080603104814.GU28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 21:31:09 +0800
Message-Id: <1212499870.3025.50.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 11:48 +0100, Al Viro wrote:
> On Tue, Jun 03, 2008 at 12:37:59PM +0200, Miklos Szeredi wrote:
> > > http://www.kerneloops.org/raw.php?rawid=12419&msgid=
> > > 
> > > Looks like a negative inode in S_ISDIR(mnt->mnt_root->d_inode->i_mode),
> > > which would be due to NFS not properly filling in its root dentry?
> > 
> > On second thought it's S_ISDIR(path->dentry->d_inode->i_mode), which
> > means it's an autofs thing.
> 
> It is path->dentry, all right, but the question is how'd it get that way.
> Look: we got that nd.path.dentry out of path_lookup() with LOOKUP_FOLLOW
> as flags.  Then we'd passed it through do_new_mount() to do_add_mount()
> without changes.  And went through
>         /* Something was mounted here while we slept */
>         while (d_mountpoint(nd->path.dentry) &&
>                follow_down(&nd->path.mnt, &nd->path.dentry))
>                 ;

And this relates to previous in that a mount isn't done by autofs until
until after the directory is created, at which time the (->mkdir())
dentry is hashed.

Ian


