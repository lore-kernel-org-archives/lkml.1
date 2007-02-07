Return-Path: <linux-kernel-owner+w=401wt.eu-S1161079AbXBGJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbXBGJZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161072AbXBGJZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:25:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:40269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161070AbXBGJZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:25:40 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Wed, 7 Feb 2007 01:25:33 -0800
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051920.36057.agruen@suse.de> <1170751912.6242.30.camel@lade.trondhjem.org>
In-Reply-To: <1170751912.6242.30.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702070125.34162.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

On Tuesday 06 February 2007 00:51, Trond Myklebust wrote:
> > But there is no way to tell different hardlinks to the same inode in the
> > same directory from each other (both the file and directory inode are the
> > same), and depending on the export options, we may or may not be able to
> > distinguish different hardlinks across directories.
>
> Who cares? There is no way to export a partial directory, and in any
> case the subtree_check crap is borken beyond repair (see cross-directory
> renames which lead to actual changes to the filehandle - broken, broken,
> broken!!!!).

I do agree that the directory inode number would better not be part of the 
filehandle. In this thread I'm trying to argue why trying to compute 
pathnames based on nfs file handles makes no sense though, and that the sane 
thing is not to even try.

> > If the nohide or crossmnt export options are used, we might run into
> > similar aliasing issues with mounts (I'm not sure about this).
>
> Wrong. Those create new export points since you are crossing into a
> different filesystem.

I'm glad to be proven wrong here. Pathnames for nfs remain meaningless even 
without mount point aliasing, though.

> > So we could compute pathnames, but they wouldn't be very meaningful.
> > Instead of going that way, it seems more reasonable to not do pathname
> > based access control for the kernel kernel nfsd at all. Passing NULL as
> > the vfsmounts does that. With a properly configured nfsd, the areas that
> > remote users could access would still be well confined.
>
> Huh? Even if you don't pass in a vfsmount, you _still_ need to pass in a
> super_block. Inodes are only unique per filesystem.

No worries, the super_block is not hanging off struct vfsmount, it's hanging 
off struct dentry.

Thanks,
Andreas
