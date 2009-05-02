Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZEBVj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZEBVj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZEBVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:39:18 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:40279 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZEBVjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org> 
	<ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com> 
	<9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 23:39:01 +0200
Message-ID: <ac3eb2510905021439r2cef54fbja601f140d76ad623@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 22:22, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:

> On a narrow issue: do you really object to moving the "mount dev -t
> devfs2 /dev" into userspace (and therefore giving it a user-visible
> name)??  That would address Cristophs particular objection about
> "messing around" with the initial namespace.

An argument which does not stand at all, there is no mess, it is not
mounted at all until we are ready with initializing the kernel. And
instead of creating some random nodes in /dev like we do today, we
mount it, and it contains a node for every device. I hardly see any of
the mentioned "namespace mess" here, it's just the simplest, most
robust, and most efficient thing we can do. :)

> It means I can be 100%
> sure I can boot an old initramfs with this option enabled.

Oh, it does not change anything for an existing initramfs, if that
option enabled. After initramfs found and mounted the real rootfs at
/root, your are totally free to call:
  mount --move /dev/ /root/dev
or not to do that, like we do today.

> And it
> gives a nice clean way for new initramfs' to test for this feature -
> when they try to mount it, it fails.  It would seem to make for a
> rather smoother migration path.

I think that is all covered just fine.

One thing that I tried to solve by doing a kernel mounted fs, is that
/dev on the rootfs is completely empty, it is that way on some distros
today, and if you do init=/bin/sh, it will not work, because
/dev/console is missing.

Another thing, why I would like to avoid a new fstype is that
userspace checks if /dev is a tmpfs to find out if it's a dynamic /dev
- nothing really that should prevent us from doing a new filesystem,
but we should need a good reason to do it, I think.

Thanks,
Kay
