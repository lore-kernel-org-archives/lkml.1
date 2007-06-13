Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbXFMKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbXFMKU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbXFMKUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:20:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47572 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbXFMKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:20:45 -0400
Date: Wed, 13 Jun 2007 06:17:39 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613101739.GV28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <170fa0d20706121253v62d13f70p3694eeab1852092a@mail.gmail.com> <20070612201439.GI28279@think.oraclecorp.com> <20070613030829.GA15724@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613030829.GA15724@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 04:08:30AM +0100, Christoph Hellwig wrote:
> On Tue, Jun 12, 2007 at 04:14:39PM -0400, Chris Mason wrote:
> > > Aside from folding snapshot history into the origin's namespace... It
> > > could be possible to have a mount.btrfs that allows subvolumes and/or
> > > snapshot volumes to be mounted as unique roots?  I'd imagine a bind
> > > mount _could_ provide this too?  Anyway, I'm just interested in
> > > understanding the vision for managing the potentially complex nature
> > > of a Btrfs namespace.
> > 
> > One option is to put the real btrfs root into some directory in
> > (/sys/fs/btrfs/$device?) and then use tools in userland to mount -o bind
> > outside of that.  I wanted to wait to get fancy until I had a better
> > idea of how people would use the feature.
> 
> We already support mounting into subdirectories of a filesystem for
> nfs connection sharing.  The patch below makes use of this to allow
> mounting any subdirectory of a btrfs filesystem by specifying it in
> the form of /dev/somedevice:directory and when no subdirectory
> is specified uses 'default'.

Neat, thanks Christoph, this will be much nicer longer term.  I'll
integrate it after I finish off -enospc.

> To make this more useful btrfs directories
> should grow some way to be marked head of a subvolume,

They are already different in the btree, but maybe I'm not 100% sure
what you mean by marked as the head of a subvolume?

> and we'd need
> a more useful way to actually create subvolumes and snapshots without
> fugly ioctls.

One way I can think of that doesn't involve an ioctl is to have a
special subdir at the root of the subvolume:

cd
/mnt/default/.snaps
mkdir new_snapshot
rmdir old_snapshot

cd /mnt
mkdir new_subvol
rmdir old_subvol

-chris

