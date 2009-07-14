Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGNSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGNSnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbZGNSm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:42:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55179 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbZGNSm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:42:59 -0400
X-Greylist: delayed 1435 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 14:42:58 EDT
Date: Tue, 14 Jul 2009 14:18:44 -0400
Message-Id: <200907141818.n6EIIiA7014311@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Add read-only users count to superblock 
In-reply-to: Your message of "Mon, 13 Jul 2009 15:27:44 EDT."
             <20090713192743.GA27582@shell> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20090713192743.GA27582@shell>, Valerie Aurora writes:
> During the last FS summit, Al Viro suggested creating a superblock
> level read-only marker so that union mounts could guarantee that the
> underlying fs would not become writable.  This patch implements the
> VFS support, but doesn't add any users.  The patch making union mounts
> use the support is in our union mounts tree.  I think we also need
> some way to pass this through NFS mounts, since a read-only NFS mount
> for the bottom layer of a union mount is a common use case.
> 
> -VAL
[...]

Val, I've often wondered if a generic readonly superblock solution will
obviate the need for the sb->s_vfs_rename_mutex "kludge" (as commented in
fs.h) and the whole way directory-renames are done wrt locking.  Can the
rename code be the first user of such patch, or the patch isn't quite ready
for this?

I realize that marking a whole superblock readonly during a directory rename
can hurt performance in some cases, as compared to the current way of doing
things, using lock_rename() to lock a subtree of the namespace.  But I
suspect that many concurrent directory renames are an exception, and thus
practical performance won't be hurt much with such a patch -- but result in
major benefits of code simplicity for several file systems (esp. for
unioning layers).

Erez.
