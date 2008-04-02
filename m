Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbYDBUzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbYDBUzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbYDBUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:55:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49997 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbYDBUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:55:04 -0400
Date: Wed, 2 Apr 2008 21:54:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080402205450.GO9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402201321.062856131@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:12:48PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> R/o bind mounts require operations which modify the filesystem to be
> wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> this, so callers won't need to bother, and more importantly, cannot
> forget!  Call these path_*, analogous to vfs_*.  Where there are no
> callers of vfs_* left, make them static.
>
> This series is a cleanup, as well as fixing several places (mostly in
> nfsd) where mnt_{want,drop}_write() were missing.
> 
> It will also help with merging You Know What(*) security module, which
> needs to know the path within the namespace, and not just within the
> filesystem.  These helpers will allow the security hooks to be in a
> common place, and need not be repeated in all callers.

Rot.

Places in nfsd must be fixed, LSM hooks *moved* *to* *callers*.  And
really, by that point I absolutely do not give a damn for these clowns.
"Help with merging" implies that they can't be arsed to do _anything_
with their code.  Just as they could not be arsed to react to any
comments (including civil ones) in any manner except "wait for a month
and repost without changes".  Sod them.

And no, "make static where all (two of) current callers have vfsmount"
is non-starter.  path_...() is (at most) a convenience helper, not a
fundamental interface - simply because new callers should not be
forced into inventing a fake vfsmount just to use that.

I'll look into missing mnt_..._write() in nfsd and fix that.  The rest...
Sorry.
