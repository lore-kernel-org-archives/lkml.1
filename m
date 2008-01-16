Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYAPXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYAPXUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYAPXPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59163 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYAPXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:21 -0500
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
In-reply-to: <20080116143051.ec488f3d.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 16 Jan 2008 14:30:51 -0800)
Subject: Re: [patch] VFS: extend /proc/mounts
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080116143051.ec488f3d.akpm@linux-foundation.org>
Message-Id: <E1JFHTW-0005Eo-N5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Jan 2008 00:15:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The reason, why this patch was dug up, is that if the bdi-sysfs patch
> > is going to use device numbers to identify BDIs, then there should be
> > a way for the user to map the device number into mount(s).
> > 
> > But it's useful regardless of the bdi-sysfs patch.
> 
> Don't know what that is.

   Subject: mm: sysfs: expose the BDI object in sysfs
   
   Provide a place in sysfs for the backing_dev_info object.
   This allows us to see and set the various BDI specific variables.
   
   In particular this properly exposes the read-ahead window for all
   relevant users and /sys/block/<block>/queue/read_ahead_kb should be
   deprecated.

> > Can this be added to -mm?
> > 
> > In theory it could break userspace, but I think it's very unlikely to
> > do so, because stuff is added only at the end of the lines, and
> > because most programs probably parse it through the libc interface
> > which is not broken by this change.  Despite this, it should be tested
> > on as many systems as possible.
> 
> Seems like a plain bad idea to me.  There will be any number of home-made
> /proc/mounts parsers and we don't know what they do.

Dunno.  I feel, this is quite safe, because even the home-grown
parsers will likely care about any junk at the end of the line.  But
of course this cannot be proved.

> > - for mount ID's use IRA instead of a 32bit counter, which could overflow
> 
> don't know what an IRA is.

That was meant to be IDA (from the IDR library).

> > - print canonical ID's (smallest one within the peer group) for peers
> >   and master, this is more useful, than a random ID within the same namespace
> > - fix a couple of small bugs
> > - style fixes
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Both the newly-added inlines in this patch are wrong.  They will result in
> a larger and slower kernel.  This should be very well known by now.

I'll get rid of them.

Miklos
