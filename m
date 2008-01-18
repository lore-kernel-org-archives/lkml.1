Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYARClw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYARClw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762066AbYARCkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:40:55 -0500
Received: from waste.org ([66.93.16.53]:40339 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762158AbYARCkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:40:53 -0500
Subject: Re: [PATCH] ramdisk driver: make rd_size non-static
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Byron Bradley <byron.bbradley@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20080117182851.f9177571.akpm@linux-foundation.org>
References: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com>
	 <20080117182851.f9177571.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 20:39:23 -0600
Message-Id: <1200623963.4001.5.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 18:28 -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2008 02:02:17 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:
> 
> > In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the
> > boot tags. The replacement ramdisk driver has rd_size as static
> > which causes linking to fail when ramdisk is built-in.
> > 
> 
> but...
> 
> > diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> > index 5ef1d26..8536480 100644
> > --- a/drivers/block/brd.c
> > +++ b/drivers/block/brd.c
> > @@ -385,7 +385,7 @@ static struct block_device_operations brd_fops = {
> >   * And now the modules code and kernel interface.
> >   */
> >  static int rd_nr;
> > -static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> > +int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> >  module_param(rd_nr, int, 0);
> >  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> >  module_param(rd_size, int, 0);
> 
> rd_size is a module parameter so it is settable via the
> syntax-which-i-can-never-remember.  rd.rd_size=1024 or something like that.
> 
> If that's all sane, do we have some back-compat reason to continue to
> support the special and duplicative rd_size parameter?

Only insofar as we're still supporting ramdisks in the first place.

-- 
Mathematics is the supreme nostalgia of our time.

