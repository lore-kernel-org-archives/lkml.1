Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYJGRd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYJGRd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYJGRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:33:50 -0400
Received: from kroah.org ([198.145.64.141]:52234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753370AbYJGRdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:33:49 -0400
Date: Tue, 7 Oct 2008 10:30:20 -0700
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Add c2 port support.
Message-ID: <20081007173020.GA16654@kroah.com>
References: <1223044589-31741-1-git-send-email-giometti@linux.it> <1223044589-31741-2-git-send-email-giometti@linux.it> <20081003215923.GA14890@kroah.com> <20081007093845.GD13035@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007093845.GD13035@tekkaman>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:38:45AM +0200, Rodolfo Giometti wrote:
> On Fri, Oct 03, 2008 at 02:59:23PM -0700, Greg KH wrote:
> > On Fri, Oct 03, 2008 at 04:36:29PM +0200, Rodolfo Giometti wrote:
> > > C2port implements a two wire serial communication protocol (bit
> > > banging) designed to enable in-system programming, debugging, and
> > > boundary-scan testing on low pin-count Silicon Labs devices.
> > > 
> > > Currently this code supports only flash programming through sysfs
> > > interface but extensions shoud be easy to add.
> > > 
> > > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> > > ---
> > >  drivers/misc/Kconfig       |   13 +
> > >  drivers/misc/Makefile      |    1 +
> > >  drivers/misc/c2port_core.c |  996 ++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/c2port.h     |   65 +++
> > 
> > Why does this file have to be in include/linux?  I don't think this
> > exports any structures to userspace, and no other code calls this
> > driver, so it should all fit into the .c file just fine.
> 
> The inlcude file is needed because you have to define a clients for
> each c2 port implementations, see here for further info:
> 
>    http://wiki.enneenne.com/index.php/Silicon_C2_Interface

You might want to flush out your Kconfig entry with more information
from this site :)

> The file c2port_core.c implements the core, a client implements the
> low level functions.

But you aren't submitting any clients here, right?  Are you planning to?

> > Is there any way to detect automatically if this hardware is present in
> > the system or not?
> 
> I don't think so. The C2 port is usually implemented with two generic
> GPIOs.

Then the default config option should be N, and you should make the
Kconfig help text a bit clearer as to exactly which machines this device
would be expected for, otherwise you might accidentally have distros add
this device to their builds, which would not be a good thing.

> I posted the code in order to get some feedbacks and then repropose
> something suitable for inclusion. So I'd like to know if I should make
> a separate subdir into linux/drivers/misc/ to hold possible clients
> (i.e. linux/drivers/misc/c2port/).

What's wrong with drivers/c2port/ ?  Come on, think big :)

thanks,

greg k-h
