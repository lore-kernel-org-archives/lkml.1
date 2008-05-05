Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYEESpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYEESpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761976AbYEEScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:32:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60920 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbYEEScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:32:06 -0400
To: miklos@szeredi.hu
CC: viro@ZenIV.linux.org.uk, miklos@szeredi.hu, weigelt@metux.de,
       linux-kernel@vger.kernel.org
In-reply-to: <E1Jt526-0006le-04@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 05 May 2008 20:03:26 +0200)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk> <E1Jt526-0006le-04@pomaz-ex.szeredi.hu>
Message-Id: <E1Jt5Td-0006rG-3E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 20:31:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >  Take a look at 9P walk - it does *not* give
> > > > you anything resembling stat, you just get qids of intermediates.
> > > 
> > > Which is exactly what's needed to populate the dentry tree, no?
> > 
> > No - you need inodes as well (i.e. as the absolute least you want
> > mode and ownership).  Which is to say, you need to issue stat on
> > each component in such situation anyway.  Not a win...

And actually even that *could* be a win, if the network latency is
large.  Because by doing the lookup first, the stats can be performed
in parallel.  So a path with an arbitrary number of components could
be resolved in just 2 RTTs.

Miklos
