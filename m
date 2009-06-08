Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZFHT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZFHT7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZFHT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:59:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZFHT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:59:10 -0400
Date: Mon, 8 Jun 2009 12:57:52 -0700
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090608195752.GD4363@fsbox>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <20090521125419.GM30663@sith.mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521125419.GM30663@sith.mimuw.edu.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 02:54:19PM +0200, Jan Rekorajski wrote:
> On Mon, 18 May 2009, Jan Blunck wrote:
> 
> > Here is another post of the VFS based union mount implementation.
> 
> Is there any chance this will support NFS? I can union-mount tmpfs over

NFS as the read-only layer ought to work.  NFS as the read-write layer
is still up in the air.

> nfs mounted fs, but if I try to mount --union two NFS filesystems I
> always get -EBUSY on second mount on the same mountpoint.
> 
> Something along these lines:
> 
> doesn't matter if I use --union on first mount, the result is always the
> same.
> 
> mount <--union> -t nfs server:/export/system /mnt
> OK
> mount --union -t nfs server:/export/profile /mnt
> mount.nfs: /mnt is busy or already mounted
> 
> I patched mount.nfs so it knows about MS_UNION, and strace shows me that
> it passes that flag to kernel.

FYI, using --union on the first mount will make it union with the
local directory below it.  The --union option is not needed when you
mount the lower read-only layer.

You'll get -EBUSY on the second mount of any NFS file system over
another - try it again with the --union flag.  Support for NFS on NFS
union mount would have to change this.

-VAL
