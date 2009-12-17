Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbZLQBAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbZLQBAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763499AbZLQBAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:00:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46307 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763520AbZLQBAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:00:37 -0500
Date: Thu, 17 Dec 2009 01:00:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
Message-ID: <20091217010032.GS14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk> <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com> <1261004048.3154.2.camel@localhost> <20091216230711.GN14381@ZenIV.linux.org.uk> <1261005194.3154.4.camel@localhost> <20091216232729.GO14381@ZenIV.linux.org.uk> <1261008131.3026.0.camel@localhost> <20091217004003.GQ14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217004003.GQ14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:40:03AM +0000, Al Viro wrote:
> On Thu, Dec 17, 2009 at 12:02:11AM +0000, Tony Vroon wrote:
> > On Wed, 2009-12-16 at 23:27 +0000, Al Viro wrote:
> > > > Do you want me to revert 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1
> > > > locally or try linux-2.6 old enough not to have this?
> > > The former.
> > 
> > That resolves the issue completely. I am now able to boot.
> 
> Oh, fsck...  I see.  Linus, the fix is added to the same branch (and
> I'll throw the fix for removed alloc_file export there in a few minutes).

Nevermind, alloc_file export had been restored in mainline already.
So just pull from the same place, same branch (
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master
), there's just that one commit on top of mainline.

What happened: in absence of CONFIG_TPMFS_POSIX_ACL, shmem_mknod() had
code that boiled down to
	error = 0; /* shmem_acl_init(...), actually */
	if (error)
		cleanup
and Christoph's patch had put all that chunk under ifdef.  Which was not
an equivalent transformation, since we could arrive there with non-zero
error.  Old code used to set it to 0, new one left as-is.
