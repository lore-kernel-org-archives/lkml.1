Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXI0Vq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXI0Vq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXI0VqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:46:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36509 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbXI0VqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:46:20 -0400
Date: Thu, 27 Sep 2007 14:36:36 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Hellwig <hch@lst.de>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 02/10] Dont touch fs_struct in usermodehelper
Message-ID: <20070927213636.GB7857@kroah.com>
References: <20070927141200.820970144@X40.localnet> <20070927141227.559764756@X40.localnet> <20070927174604.GA8339@kroah.com> <20070927203922.GA15477@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927203922.GA15477@lst.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 10:39:22PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 27, 2007 at 10:46:04AM -0700, Greg KH wrote:
> > On Thu, Sep 27, 2007 at 04:12:02PM +0200, jblunck@suse.de wrote:
> > > This test seems to be unnecessary since we always have rootfs mounted before
> > > calling a usermodehelper.
> > 
> > Are you sure this is true?  I thought we called the usermode helper for
> > hotplug _very_ early in the boot sequence when the device tree starts to
> > get populated.
> 
> rootfs is mounted by init_mount_tree, and curret->fs is set up for init
> there aswell.  This is called by mnt_init, which is called by
> vfs_caches_init, which is called by start_kernel far before we go to
> rest_init which finally creates a thread to call kernel_init which then
> calls do_basic_setup which calls do_initcalls to initialize drivers and
> afterwards runs the initrd/initramfs.
> 
> While the actual function names in main.c changed quite a bit we've
> initialized the initial namespace very early on since the 2.5 days.

Ah, ok, great, thanks for correcting me.  I have no objection to this
patch then.

thanks,

greg k-h
