Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0BVUaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:30:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55819 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0BVUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:30:00 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: hch@infradead.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, eugene@redhat.com, mtk.manpages@gmail.com,
       7eggert@web.de
In-reply-to: <20100221020144.GV30031@ZenIV.linux.org.uk> (message from Al Viro
	on Sun, 21 Feb 2010 02:01:44 +0000)
Subject: Re: [PATCH v2] vfs: add NOFOLLOW flag to umount(2)
References: <E1NfAXx-0000ln-59@pomaz-ex.szeredi.hu>
 <20100211172100.GA28533@infradead.org> <20100221020144.GV30031@ZenIV.linux.org.uk>
Message-Id: <E1Njeua-0000Fd-2b@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Feb 2010 21:29:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Al Viro wrote:
> On Thu, Feb 11, 2010 at 12:21:00PM -0500, Christoph Hellwig wrote:
> > On Wed, Feb 10, 2010 at 12:15:53PM +0100, Miklos Szeredi wrote:
> > >  - renamed flag to UMOUNT_NOFOLLOW
> > >  - added UMOUNT_UNUSED for feature detection
> > 
> > Umm, why?  MNT_ certainly isn't the best naming for unmount flags,
> > but switching convention after we had a few doesn't make any sense.
> 
> Actually, I've got more interesting question: what's being attempted
> there?  Is that just a "let's protect ourselves against somebody feeding
> us an untrusted symlink"?  I'm not sure if it makes much sense; if we
> are dealing with pathnames on untrusted fs, there's nothing to stop the
> attacker from having /mnt/foo/dir (originally containing a mountpoint
> at /mnt/foo/dir/usr) killed and replaced with a symlink to /, making any
> code that does umount() on such pathnames vulnerable as hell anyway.

It is trivial to check the path up to the mountpoint (chdir + getcwd).
But doing that on the mountpoint will make it busy, so NOFOLLOW is
really needed there.

Thanks,
Miklos
