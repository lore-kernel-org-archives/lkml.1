Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXHFSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXHFSbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXHFSbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:31:39 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59387 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbXHFSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:31:36 -0400
To: jlayton@redhat.com
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu,
       cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
       xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com,
       reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
       fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
       user-mode-linux-user@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
       linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
       bfennema@falcon.csc.calpoly.edu
In-reply-to: <20070806141333.0f54ab17.jlayton@redhat.com> (message from Jeff
	Layton on Mon, 6 Aug 2007 14:13:33 -0400)
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
 notify_change into helper function
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu> <20070806141333.0f54ab17.jlayton@redhat.com>
Message-Id: <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Aug 2007 20:28:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I agree with this change and fuse will make use of it as well.
> > 
> > Maybe instead of unconditionally moving attr_kill_to_mode() inside
> > ->setattr() it could be made conditional based on an inode flag
> > similarly to S_NOCMTIME.  Advantages:
> > 
> >  - no need to modify a lot of in-tree filesystems
> >  - no silent breakage of out-of-tree fs
> > 
> > Actually I think the new flag would be used by exacly the same
> > filesystems as S_NOCMTIME, so maybe it would make sense to rename
> > S_NOCMTIME to something more generic (S_NOATTRUPDATE or whatever) and
> > use that.
> > 
> > But that could still break out-of-tree fs, so a separate flag is
> > probably better.
> > 
> 
> In the past I've been told that adding new flags is something of a
> "last resort". Since it's not strictly necessary to fix this then
> it may be best to avoid that.
> 
> That said, if the concensus is that we need a transition mechanism,
> then I'd be open to such a suggestion.

I think there's really no other choice here.

Your patch is changing the API in a very unsafe way, since there will
be no error or warning on an unconverted fs.  And that could lead to
security holes.

If we would rename the setattr method to setattr_new as well as
changing it's behavior, that would be fine.  But I guess we do not
want to do that.

Miklos
