Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYIKQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYIKQ27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYIKQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:28:50 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49514 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYIKQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:28:49 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Theodore Tso <tytso@mit.edu>, Faidon Liambotis <paravoid@debian.org>,
       David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <48C92CFE.2030803@suse.com>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <48C8BC17.5050508@debian.org> <48C8C580.5020803@suse.com>
	 <20080911133847.GD5082@mit.edu>  <48C92CFE.2030803@suse.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:29:18 +0200
Message-Id: <1221150558.6309.50.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> >> In the end, though, Andrew's right. We can't go breaking udev prior to
> >> 127 with this.
> > 
> > But it's OK to break various distribution's kernel packaging tools?
> 
> No. I still think the right answer is to keep them in a versioned
> directory and I'm keeping this patch applied to the SUSE kernel trees.
> Udev in the next release understands where to look. It's just clear that
> there's some disagreement if that's the right answer for everyone. My
> opinion is that if the firmware blobs are built with and shipped with
> the kernel, then they're already associated with a particular kernel
> version as a dependency the same way we'd treat module dependencies.

no they don't depend on a kernel version. The firmware depends on a
specific driver version (and hardware in some cases). The kernel version
is totally irrelevant in this case.

> It's silly to willfully complicate the situation beyond just including
> the firmware blobs with the kernel. Even though it sounds a lot simpler
> to just say, "keep a separate firmware package," the reality is that it
> creates more work for everyone, developers, users, and packagers alike.
> I recently updated the kernel on my notebook to a 2.6.27-rc, only to
> find out that the firmware blob that I already had installed was out of
> date and the driver was useless without it. This is an example of an
> externally-maintained firmware blob, but creating a separate package out
> of firmware blobs essentially makes all of them externally maintained
> and forces in-kernel developers to jump through the same hoops that
> third-party driver maintainers must.
> 
> Packagers will need to keep track of every firmware version associated
> with every kernel, since users may want to install multiple kernel
> versions. This is the entire point of the thread, and it assumes that
> the user installing the kernel is even using a packaged kernel. If
> they've just built their own and have done a make modules_install ; make
> install, then they're out of luck.

We do have MODULE_FIRMWARE for that.

> Putting them in their own directory just makes it obvious and easy for
> everyone. The issue is that firmware.sh isn't looking there right now.
> Perhaps making optional symlinks is the answer.

Making symlinks is just a workaround. It will not solve anything in the
long term.

Getting all the firmware out of the kernel and getting it into a
separate package is the solution. And to avoid any breakage or problems
the firmware files itself have to be versioned. Firmware like every
other software has its version numbers already. It is like any other API
and once you break it in an incompatible why, you should increase the
major version number. The kernel version has nothing to do with it.

Regards

Marcel


