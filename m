Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJGJj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJGJj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYJGJjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:39:21 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57778 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYJGJjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:39:20 -0400
Date: Tue, 7 Oct 2008 11:38:45 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20081007093845.GD13035@tekkaman>
References: <1223044589-31741-1-git-send-email-giometti@linux.it> <1223044589-31741-2-git-send-email-giometti@linux.it> <20081003215923.GA14890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003215923.GA14890@kroah.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] Add c2 port support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 02:59:23PM -0700, Greg KH wrote:
> On Fri, Oct 03, 2008 at 04:36:29PM +0200, Rodolfo Giometti wrote:
> > C2port implements a two wire serial communication protocol (bit
> > banging) designed to enable in-system programming, debugging, and
> > boundary-scan testing on low pin-count Silicon Labs devices.
> > 
> > Currently this code supports only flash programming through sysfs
> > interface but extensions shoud be easy to add.
> > 
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> > ---
> >  drivers/misc/Kconfig       |   13 +
> >  drivers/misc/Makefile      |    1 +
> >  drivers/misc/c2port_core.c |  996 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/c2port.h     |   65 +++
> 
> Why does this file have to be in include/linux?  I don't think this
> exports any structures to userspace, and no other code calls this
> driver, so it should all fit into the .c file just fine.

The inlcude file is needed because you have to define a clients for
each c2 port implementations, see here for further info:

   http://wiki.enneenne.com/index.php/Silicon_C2_Interface

The file c2port_core.c implements the core, a client implements the
low level functions.

> Also, please create the needed Documentation/ABI/ files for these new
> sysfs entries, describing how they are used, and what the format of them
> are.

Ok.

> Is there any way to detect automatically if this hardware is present in
> the system or not?

I don't think so. The C2 port is usually implemented with two generic
GPIOs.

> Otherwise, how will it be loaded by a distro automatically?

The C2 port client is usually defined into platform machine data file,
for example I defined my client into linux/arch/arm/mach-pxa/wr1100.c
(wr1100.c is not in a vanilla tree, refere to mainstone.c for similar
code). In this manner the driver is autoloaded at boot time.

I posted the code in order to get some feedbacks and then repropose
something suitable for inclusion. So I'd like to know if I should make
a separate subdir into linux/drivers/misc/ to hold possible clients
(i.e. linux/drivers/misc/c2port/).

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
