Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYEESEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYEESEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYEESDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:03:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49989 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYEESDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:03:38 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, weigelt@metux.de, linux-kernel@vger.kernel.org
In-reply-to: <20080505174048.GP5882@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 5 May 2008 18:40:48 +0100)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk>
Message-Id: <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 20:03:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This is still wrong.  We not just pass the pathname to filesystem (note
> > > that you still need to deal with symlinks),
> > 
> > Symlinks are easy: filesystem just needs to *stop* the resolution the
> > moment it finds one.
> 
> That assumes you see types of objects as you do multi-step walk...

Umm, OK.  The 9P server does see the type of objects, so it should be
able to do that.

> > >  Take a look at 9P walk - it does *not* give
> > > you anything resembling stat, you just get qids of intermediates.
> > 
> > Which is exactly what's needed to populate the dentry tree, no?
> 
> No - you need inodes as well (i.e. as the absolute least you want
> mode and ownership).  Which is to say, you need to issue stat on
> each component in such situation anyway.  Not a win...

You're right.  It doesn't sound too good, although it all depends on
the how permission checking is done.  If it's done in the server, then
neither the mode nor the ownership is needed for lookup.  The file
type *is* known for all but the last component, and doing a stat for
that one is not a big issue.  All this is modulo the symlink issue of
course.

Miklos
