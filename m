Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXFIU4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXFIU4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbXFIU4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:56:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60302 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759030AbXFIU4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:56:33 -0400
Date: Sat, 9 Jun 2007 22:57:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rich Chase <rac47.02@engalumni.colostate.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
Message-ID: <20070609205733.GB1641@uranus.ravnborg.org>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu> <20070608201947.GD25468@uranus.ravnborg.org> <200706091224.15162.rac47.02@engalumni.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706091224.15162.rac47.02@engalumni.colostate.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 12:24:14PM -0400, Rich Chase wrote:
> Sam,
> Thanks for the feedback. I need more ideas. See 
> responses to your ideas below.
> 
> 
> Yes, I was attempting to compile gspcav1, a webcam 
> driver. It can be found at:
>   http://mxhaard.free.fr/download.html

>From the Makefile:

KERNEL_VERSION = `uname -r`
KERNELDIR := /lib/modules/$(KERNEL_VERSION)/build
PWD  := $(shell pwd)
MODULE_INSTALLDIR = /lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/media/
MODULE_INSTALLDIR2 = /lib/modules/$(KERNEL_VERSION)/kernel/drivers/media/video/

default:
        $(MAKE) -C $(KERNELDIR) SUBDIRS=$(PWD) CC=$(CC) modules


So you need to check:
1) That your running kernel is indeed installed as /lib/modules/`uname -r`
2) That /lib/modules/`uname -r`/build are a proper symlink to
your kernel source including the build files.

Try to do: ls /lib/modules/`uname -r`/build/scripts

If this is OK then add V=1 to make invocation liek this:
        $(MAKE) -C $(KERNELDIR) SUBDIRS=$(PWD) CC=$(CC) V=1 modules

and send the full output.

	Sam
