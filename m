Return-Path: <linux-kernel-owner+w=401wt.eu-S939410AbXFHPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939410AbXFHPvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938307AbXFHPvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:51:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:50931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936702AbXFHPvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:51:44 -0400
Date: Fri, 8 Jun 2007 08:50:27 -0700
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Peter Jones <pjones@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070608155027.GA7833@suse.de>
References: <20070607154342.GA16911@suse.de> <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de> <20070607184805.GA28551@nostromo.devel.redhat.com> <20070607200102.GA21653@suse.de> <20070607233258.063f6cfa@the-village.bc.nu> <20070607230904.GA7344@suse.de> <6712.1181316818@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6712.1181316818@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:33:38AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 07 Jun 2007 16:09:04 PDT, Greg KH said:
> > If CONFIG_SYSFS_DEPRECATED everything should work just fine with all old
> > initrd scripts.  It's only if you enable that option (which is enabled
> > by default) that you need to ensure that your distro has the latest
> > functionality so that everything works properly.
> 
> Can somebody document what an initrd has to do differently?  Some of us
> run with initrd's not created by mkinitrd.

So I'm guessing that you wrote your own initrd?

The main issue is that /sys/block/ is now full of symlinks, not real
directories, if CONFIG_SYSFS_DEPRECATED is not enabled.  That means that
any program that was doing stat() should be doing lstat() for the block
directory to work on all instances (remember, whenever looking for a
directory or a file in sysfs, it could be either a real file/directory
or a symlink, you should not care either way.)

People have also reported that for some reason, removing the '--movedev'
argument to switchroot is also needed, but that might just be a Fedora 7
specific thing, I'm not quite sure.

See the post from Alan Stern on lkml with the subject:
	Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4 testers wanted)

for more details on that.

Hope this helps,

greg k-h
