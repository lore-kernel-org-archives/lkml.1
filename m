Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751736AbYLRQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbYLRQpn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLRQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:45:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40659 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYLRQpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:45:20 -0500
To: raven@themaw.net
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
        dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk
In-reply-to: <alpine.LFD.2.00.0812171350350.11591@zeus.themaw.net> (message
	from Ian Kent on Wed, 17 Dec 2008 14:21:02 +0900 (WST))
Subject: Re: [rfc git patch] union directory
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0812171350350.11591@zeus.themaw.net>
Message-Id: <E1LDLzo-0007oD-Lg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 18 Dec 2008 17:45:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Ian Kent wrote:
> On Fri, 28 Nov 2008, Miklos Szeredi wrote:
> 
> > I've been doing some small fixing/cleanup work on the union directory
> > patches by Jan, and just noticed there's a thread about the union
> > mounts on LKML, so I thought publicizing won't hurt.
> > 
> > It's still a work in progress, notably the readdir code currently only
> > works on a few specific filesystem types.
> > 
> > Git tree is here:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git union-dir
> 
> I'm confused?
> 
> This doesn't look like the complete set of Jan Blunks union mount
> patches.  Am I mistaken?

You're not mistaken, this is not the original patch set, but a reduced
one (also by Jan), further reduced and cleaned up by me.

The original patch set implemented deep unioning of directory trees.
This one implements only unioning of the mount's top level directory.

> But this also made me think about the issues surrounding whiteout support 
> as having to add per-file system support for such things is bound to lead 
> to a maintenance headache. So why not a well defined modular interface 
> layer that includes these bits and is also responsible for context 
> persistence, independent of file system?

I don't think such a layer is in the scope of this patch set.  It may
be a nice thing, but it will almost certainly be implemented in a
filesystem, not in the VFS.  Union mounts, as opposed to unionfs and
its ilk, are supposed to be very lightweight.

Miklos
