Return-Path: <linux-kernel-owner+w=401wt.eu-S964911AbXBLNG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911AbXBLNG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 08:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964910AbXBLNG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 08:06:29 -0500
Received: from mlf.linux.rulez.org ([192.188.244.13]:1174 "EHLO
	mlf.linux.rulez.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909AbXBLNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 08:06:28 -0500
X-Greylist: delayed 1605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 08:06:28 EST
Date: Mon, 12 Feb 2007 13:39:39 +0100 (MET)
From: Szakacsits Szabolcs <szaka@sienet.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] add filesystem subtype support
In-Reply-To: <E1HGZhm-0003eb-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.21.0702121259540.25964-100000@mlf.linux.rulez.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, 12 Feb 2007, Miklos Szeredi wrote:

> There's a slight problem with filesystem type representation in fuse
> based filesystems.
> 
> >From the kernel's view, there are just two filesystem types: fuse and
> fuseblk.  From the user's view there are lots of different filesystem
> types.  The user is not even much concerned if the filesystem is fuse
> based or not.  

Yes. Those who are concerned with the fstype and mount like

    mount -t fstype device mountpoint

apparently expect mount/fstab line like

    device mountpoint fstype ...

Of course the fstype could be fuse.subtype or fuseblk.subtype but that 
would add a needless complexity (also, for example ntfs-3g uses both and 
it decides run-time which one to use).

> So there's a conflict of interest in how this should be
> represented in fstab, mtab and /proc/mounts.
> 
> The current scheme is to encode the real filesystem type in the mount
> source.  So an sshfs mount looks like this:
> 
>   sshfs#user@server:/   /mnt/server    fuse   rw,nosuid,nodev,...
> 
> This url-ish syntax works OK for sshfs and similar filesystems.
> However for block device based filesystems (ntfs-3g, zfs) it doesn't
> work, since the kernel expects the mount source to be a real device
> name.
> 
> A possibly better scheme would be to encode the real type in the type
> field as "type.subtype".  So fuse mounts would look like this:
> 
>   /dev/hda1       /mnt/windows   fuseblk.ntfs-3g   rw,...
>   user@server:/   /mnt/server    fuse.sshfs        rw,nosuid,nodev,...

I think it's definitely an improvement because it solves real problems, 
though perhaps not the way users would expect.

	Szaka

