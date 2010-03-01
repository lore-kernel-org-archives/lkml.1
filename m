Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0CAKFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:05:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50585 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:05:20 -0500
To: John Johansen <john.johansen@canonical.com>
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <4B87FFE1.7040001@canonical.com> (message from John Johansen on
	Fri, 26 Feb 2010 09:07:45 -0800)
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com> <E1NkyyX-0000l1-01@pomaz-ex.szeredi.hu> <4B87FFE1.7040001@canonical.com>
Message-Id: <E1Nm2V2-0006d5-Ri@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Mar 2010 11:05:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, John Johansen wrote:
> On 02/26/2010 04:07 AM, Miklos Szeredi wrote:
> > On Sat, 20 Feb 2010, john.johansen@canonical.co wrote:
> >> From: John Johansen<john.johansen@canonical.com>
> >>
> >> When __d_path() hits a lazily unmounted mount point, it tries to prepend
> >> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> >> and also overwrites the slash that separates the name from the following
> >> pathname component. This patch fixes that; if a process was in directory
> >> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> >> missing slash), while the new result with this patch is ``/foo/bar''.
> >
> > Example:
> >
> > # mkdir -p /tmp/foo/bar
> > # mkdir /tmp/mnt
> > # mount --bind /tmp/foo /tmp/mnt
> > # cd /tmp/mnt/bar
> > # /bin/pwd
> > /tmp/mnt/bar
> > # umount -l /tmp/mnt
> > # /bin/pwd
> > foobar
> >
> > After the patch it will be /foo/bar.
> >
> > Why is the path starting with "/foo"?  Does that make any sense?
> >
> not a lot except, connecting disconnected paths to root is what
> is currently done for paths that aren't reachable but have an fs
> as their root (ie the last dentry is / so it looks connected to
> root).

/tmp (which contains /foo/bar) is not a root of anything.  So even
that logic doesn't hold for your current patch.

/tmp/foo *was* the root of the mount, so "/bar" would make a tiny
little more sense.  But "/bar" looks like a normal connected patch,
which it is not, so it's not really a good solution either.

Thanks,
Miklos
