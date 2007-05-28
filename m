Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbXE1Oov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbXE1Oov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXE1Oon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:44:43 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:41040 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXE1Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:44:42 -0400
To: pavel@ucw.cz
CC: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <20070524120731.GC7444@ucw.cz> (message from Pavel Machek on Thu,
	24 May 2007 12:07:32 +0000)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070524120731.GC7444@ucw.cz>
Message-Id: <E1HsgRc-0006Di-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 May 2007 16:43:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As for unlink...  How do you deal with having that thing
> > > mounted, mounting something _under_ it (so that vfsmount would be kept
> > > busy) and then unlinking that sucker?
> > 
> > Yeah, that's a good point.  Current patch doesn't deal with that.
> > Simplest solution could be to disallow submounting these.  Don't think
> > it makes much sense anyway.
> 
> Hmmm, cd foo.tgz/bar/baz.tgz/xyzzy makes sense, and it is implemented
> as a submount, no?

Yes, that certainly makes sense, but it's the same "special" mount,
which goes away automatically, so there isn't any problem with
unlinking with any number of such submounts.

But I don't want to explicitly prohibit submounting by normal mounts
either, if it's not too hard to handle, and Al's new vfsmount
refcounting scheme should take care of the difficult part of that.

Miklos
