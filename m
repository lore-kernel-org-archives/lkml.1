Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYJNMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYJNMoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYJNMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:43:48 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45374 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYJNMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:43:48 -0400
To: szaka@ntfs-3g.org
CC: miklos@szeredi.hu, tj@kernel.org, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.61.0810141512570.14752@dhcppc2> (message from
	Szabolcs Szakacsits on Tue, 14 Oct 2008 15:16:43 +0300 (MET DST))
Subject: Re: [fuse-devel] [PATCHSET] FUSE: extend FUSE to support more
 operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
 <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <Pine.LNX.4.61.0810141512570.14752@dhcppc2>
Message-Id: <E1KpjF2-0007jD-B4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Oct 2008 14:43:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008, Szabolcs Szakacsits wrote:
> On Tue, 14 Oct 2008, Miklos Szeredi wrote:
> 
> > I still got qualms about this ioctl thing.  One is the security
> > aspect, but that could be dealt with.  The other is that I really
> > really don't want people to start implementing new custom ioctls for
> > their filesystems, as I think that way lies madness.  We could limit
> > ioctls to CUSE and that would be fine with me.  Or for non-CUSE users
> > we could enforce the "standard" format where the type and length is
> > encoded in the command number.
> 
> Is this enough to support the most useful/requested file system ioctls, 
> like FIEMAP?

Looking at FIEMAP patches...

No, FIEMAP doesn't seem fit in that category.  But FIEMAP has a
specific handler, so it would not get as far as the generic ioctl
handler anyway.  If we need FIEMAP support in fuse, that will need to
be handled independently of the generic ioctls (just like FIBMAP).

Miklos
