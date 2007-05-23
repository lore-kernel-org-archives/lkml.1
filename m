Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXEWJgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXEWJgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXEWJgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:36:39 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:40297 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbXEWJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:36:38 -0400
To: jblunck@suse.de
CC: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <4de7f8a60705230221m76fc55a3jc48a0d19c086fb3b@mail.gmail.com>
	(jblunck@suse.de)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
	 <20070522221045.GH4095@ftp.linux.org.uk>
	 <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <4de7f8a60705230221m76fc55a3jc48a0d19c086fb3b@mail.gmail.com>
Message-Id: <E1HqnG2-0001WL-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 11:35:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As for unlink...  How do you deal with having that thing
> > > mounted, mounting something _under_ it (so that vfsmount would be kept
> > > busy) and then unlinking that sucker?
> >
> > Yeah, that's a good point.  Current patch doesn't deal with that.
> > Simplest solution could be to disallow submounting these.  Don't think
> > it makes much sense anyway.
> >
> 
> Hmm, think about /your/path/qemu-disk1.img/boot ,
> /your/path/qemu-disk2.img/usr , ...

I get it.

It could probably be done with a little added complexity.  For example
when a real mount is attached onto a dir-on-file mount, the
"mountedness" is propagated up to the dentry on the next real mount.

So in that case unlink won't be allowed, even if the immediate
attachment is a dir-on-file mount.

This is tricky to do right though.

Other possibility is to detach all mount trees attached to dentry on
unlink.

Miklos
