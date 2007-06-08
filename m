Return-Path: <linux-kernel-owner+w=401wt.eu-S1031675AbXFHSq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031675AbXFHSq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966574AbXFHSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:46:08 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55218 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969107AbXFHSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:46:06 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 14:44:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Pete Zaitcev <zaitcev@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
In-Reply-To: <20070608183232.GA12967@kroah.com>
Message-ID: <Pine.LNX.4.64.0706081440340.9344@localhost.localdomain>
References: <46699945.6020106@redhat.com> <Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
 <20070608183232.GA12967@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Greg KH wrote:

> On Fri, Jun 08, 2007 at 02:05:22PM -0400, Robert P. J. Day wrote:
> > On Fri, 8 Jun 2007, Chuck Ebbert wrote:
> >
> > > We just found a file with this name in 2.6.21:
> > >
> > > Directory name: /sys/module/nousb/parameters
> > > File name:      ""
> > >
> > > IOW the file has an empty name. Is this intentional?
> > > It sure confuses updatedb...
> > >
> > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242715
> >
> > that appears to be the result of:
> >
> > $ grep -r __module_param_call *
> > drivers/usb/core/usb.c:__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
> > include/linux/moduleparam.h:#define __module_param_call(prefix, name, set, get, arg, perm)              \
> > include/linux/moduleparam.h:    __module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
> >
> >   and from drivers/usb/core/usb.c:
> >
> > /* format to disable USB on kernel command line is: nousb */
> > __module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
> >
> >   one has to wonder about the value of a macro that is invoked only
> > once throughout the entire tree.
>
> Pete added that back in December of 2005 (git-blame rocks...).  So what
> has changed recently to cause this to do different things in sysfs?
>
> Robert, what do you suggest we change this usage to look like?

um ... i'm fairly sure i'm totally the wrong person to be asked about
this, but what does any of the above have to do with disabling USB on
the kernel command line?  wouldn't you typically define a kernel
command line option with something like:
...
arch/i386/kernel/traps.c:__setup("kstack=", kstack_setup);
arch/i386/kernel/traps.c:__setup("code_bytes=", code_bytes_setup);
arch/i386/kernel/nmi.c:__setup("nmi_watchdog=", setup_nmi_watchdog);
arch/i386/kernel/reboot.c:__setup("reboot=", reboot_setup);
arch/i386/kernel/tsc.c:__setup("notsc", tsc_setup);
...

you know -- that sort of thing.  i mean, that's where *i'd* introduce
a "nousb" option.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
