Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYARL3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYARL3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYARL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:29:23 -0500
Received: from ns1.suse.de ([195.135.220.2]:48767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbYARL3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:29:22 -0500
Date: Fri, 18 Jan 2008 12:29:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Byron Bradley <byron.bbradley@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] ramdisk driver: make rd_size non-static
Message-ID: <20080118112920.GA27344@wotan.suse.de>
References: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com> <20080117182851.f9177571.akpm@linux-foundation.org> <1200623963.4001.5.camel@cinder.waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200623963.4001.5.camel@cinder.waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 08:39:23PM -0600, Matt Mackall wrote:
> 
> On Thu, 2008-01-17 at 18:28 -0800, Andrew Morton wrote:
> > On Fri, 18 Jan 2008 02:02:17 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:
> > 
> > > In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the
> > > boot tags. The replacement ramdisk driver has rd_size as static
> > > which causes linking to fail when ramdisk is built-in.
> > > 
> > 
> > but...
> > 
> > > diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> > > index 5ef1d26..8536480 100644
> > > --- a/drivers/block/brd.c
> > > +++ b/drivers/block/brd.c
> > > @@ -385,7 +385,7 @@ static struct block_device_operations brd_fops = {
> > >   * And now the modules code and kernel interface.
> > >   */
> > >  static int rd_nr;
> > > -static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> > > +int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> > >  module_param(rd_nr, int, 0);
> > >  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> > >  module_param(rd_size, int, 0);
> > 
> > rd_size is a module parameter so it is settable via the
> > syntax-which-i-can-never-remember.  rd.rd_size=1024 or something like that.
> > 
> > If that's all sane, do we have some back-compat reason to continue to
> > support the special and duplicative rd_size parameter?
> 
> Only insofar as we're still supporting ramdisks in the first place.

I don't care about initrd or even a backward compatible API myself, I
do have my own reason want this new rd driver in the tree...

Would be nice to get rid of the arch stuff, but it's not too terrible
(at least from the POV of drivers/block/brd.c. So thanks for the patch,
Byron.

