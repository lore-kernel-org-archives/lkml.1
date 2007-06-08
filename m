Return-Path: <linux-kernel-owner+w=401wt.eu-S970887AbXFHSdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970887AbXFHSdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970715AbXFHScj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:32:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970661AbXFHSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:32:38 -0400
Date: Fri, 8 Jun 2007 11:32:32 -0700
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Pete Zaitcev <zaitcev@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
Message-ID: <20070608183232.GA12967@kroah.com>
References: <46699945.6020106@redhat.com> <Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 02:05:22PM -0400, Robert P. J. Day wrote:
> On Fri, 8 Jun 2007, Chuck Ebbert wrote:
> 
> > We just found a file with this name in 2.6.21:
> >
> > Directory name: /sys/module/nousb/parameters
> > File name:      ""
> >
> > IOW the file has an empty name. Is this intentional?
> > It sure confuses updatedb...
> >
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242715
> 
> that appears to be the result of:
> 
> $ grep -r __module_param_call *
> drivers/usb/core/usb.c:__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
> include/linux/moduleparam.h:#define __module_param_call(prefix, name, set, get, arg, perm)              \
> include/linux/moduleparam.h:    __module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
> 
>   and from drivers/usb/core/usb.c:
> 
> /* format to disable USB on kernel command line is: nousb */
> __module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
> 
>   one has to wonder about the value of a macro that is invoked only
> once throughout the entire tree.

Pete added that back in December of 2005 (git-blame rocks...).  So what
has changed recently to cause this to do different things in sysfs?

Robert, what do you suggest we change this usage to look like?

thanks,

greg k-h
