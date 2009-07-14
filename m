Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZGNUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZGNUag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZGNUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:30:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbZGNUaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:30:35 -0400
Date: Tue, 14 Jul 2009 16:30:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Add read-only users count to superblock
Message-ID: <20090714203011.GG27582@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907141818.n6EIIiA7014311@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 02:18:44PM -0400, Erez Zadok wrote:
> In message <20090713192743.GA27582@shell>, Valerie Aurora writes:
> > During the last FS summit, Al Viro suggested creating a superblock
> > level read-only marker so that union mounts could guarantee that the
> > underlying fs would not become writable.  This patch implements the
> > VFS support, but doesn't add any users.  The patch making union mounts
> > use the support is in our union mounts tree.  I think we also need
> > some way to pass this through NFS mounts, since a read-only NFS mount
> > for the bottom layer of a union mount is a common use case.
> > 
> > -VAL
> [...]
> 
> Val, I've often wondered if a generic readonly superblock solution will
> obviate the need for the sb->s_vfs_rename_mutex "kludge" (as commented in
> fs.h) and the whole way directory-renames are done wrt locking.  Can the
> rename code be the first user of such patch, or the patch isn't quite ready
> for this?

I'm afraid not!  With this patch, you can only mark the superblock
(and all associated mounts) read-only if no files are open for writing
- not exactly the common case during a directory rename.  So no, it
can't replace the rename mutex, at least in its current form.

-VAL
