Return-Path: <linux-kernel-owner+w=401wt.eu-S1031883AbXFHSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031883AbXFHSvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031682AbXFHSum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:50:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55470 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937727AbXFHSuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:50:40 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 14:48:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Pete Zaitcev <zaitcev@redhat.com>
cc: Greg KH <greg@kroah.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
In-Reply-To: <20070608114835.7a5af390.zaitcev@redhat.com>
Message-ID: <Pine.LNX.4.64.0706081448080.9908@localhost.localdomain>
References: <46699945.6020106@redhat.com> <Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
 <20070608183232.GA12967@kroah.com> <20070608114835.7a5af390.zaitcev@redhat.com>
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

On Fri, 8 Jun 2007, Pete Zaitcev wrote:

> On Fri, 8 Jun 2007 11:32:32 -0700, Greg KH <greg@kroah.com> wrote:
>
> > >   and from drivers/usb/core/usb.c:
> > >
> > > /* format to disable USB on kernel command line is: nousb */
> > > __module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
>
> > Pete added that back in December of 2005 (git-blame rocks...).  So what
> > has changed recently to cause this to do different things in sysfs?
> >
> > Robert, what do you suggest we change this usage to look like?
>
> Aww. I thought it was a nice patch, but my foresight was inadequate.
>
> The problem I tried to fix was related to strncmp used in the code which
> supported __setup(). Our installer, Anaconda, recognizes both "nousb" and
> "nousbstorage" - in theory. In practice, passing "nousbstorage" switched
> USB completely off because of improper strncmp(). If we back out my patch,
> this problem is going to reoccur.
>
> We might want to ask Jeremy Katz if "nousbstorage" is even used anymore,
> then revert all this if not. Or, we can add a name somehow and live
> with it visible in sysfs...

there appears to be no reference to "nousbstorage" anywhere in the
tree.  go for it.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
