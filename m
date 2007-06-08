Return-Path: <linux-kernel-owner+w=401wt.eu-S970264AbXFHQM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970264AbXFHQM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030487AbXFHQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:12:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:56034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969936AbXFHQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:12:10 -0400
Date: Fri, 8 Jun 2007 09:11:34 -0700
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Peter Jones <pjones@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070608161134.GA9705@suse.de>
References: <20070607085200.f8d6e2d3.akpm@linux-foundation.org> <20070607155953.GA17591@suse.de> <20070607090632.cfcf02e6.akpm@linux-foundation.org> <20070607161525.GA18363@suse.de> <20070607184805.GA28551@nostromo.devel.redhat.com> <20070607200102.GA21653@suse.de> <20070607233258.063f6cfa@the-village.bc.nu> <20070607230904.GA7344@suse.de> <6712.1181316818@turing-police.cc.vt.edu> <20070608155027.GA7833@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608155027.GA7833@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 08:50:27AM -0700, Greg KH wrote:
> On Fri, Jun 08, 2007 at 11:33:38AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 07 Jun 2007 16:09:04 PDT, Greg KH said:
> > > If CONFIG_SYSFS_DEPRECATED everything should work just fine with all old
> > > initrd scripts.  It's only if you enable that option (which is enabled
> > > by default) that you need to ensure that your distro has the latest
> > > functionality so that everything works properly.
> > 
> > Can somebody document what an initrd has to do differently?  Some of us
> > run with initrd's not created by mkinitrd.
> 
> So I'm guessing that you wrote your own initrd?
> 
> The main issue is that /sys/block/ is now full of symlinks, not real
> directories, if CONFIG_SYSFS_DEPRECATED is not enabled.  That means that
> any program that was doing stat() should be doing lstat() for the block
> directory to work on all instances (remember, whenever looking for a
> directory or a file in sysfs, it could be either a real file/directory
> or a symlink, you should not care either way.)

Oops, sorry about that, it should be the other way around, stat(), not
lstat().

greg k-h
