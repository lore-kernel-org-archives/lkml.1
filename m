Return-Path: <linux-kernel-owner+w=401wt.eu-S969663AbXFHSIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969663AbXFHSIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031117AbXFHSHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:07:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52808 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970046AbXFHSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:07:30 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 14:05:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Chuck Ebbert <cebbert@redhat.com>
cc: USB development list <linux-usb-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: blank filenames in /sys/modules, kernel 2.6.21
In-Reply-To: <46699945.6020106@redhat.com>
Message-ID: <Pine.LNX.4.64.0706081402510.7805@localhost.localdomain>
References: <46699945.6020106@redhat.com>
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

On Fri, 8 Jun 2007, Chuck Ebbert wrote:

> We just found a file with this name in 2.6.21:
>
> Directory name: /sys/module/nousb/parameters
> File name:      ""
>
> IOW the file has an empty name. Is this intentional?
> It sure confuses updatedb...
>
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242715

that appears to be the result of:

$ grep -r __module_param_call *
drivers/usb/core/usb.c:__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
include/linux/moduleparam.h:#define __module_param_call(prefix, name, set, get, arg, perm)              \
include/linux/moduleparam.h:    __module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)

  and from drivers/usb/core/usb.c:

/* format to disable USB on kernel command line is: nousb */
__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);

  one has to wonder about the value of a macro that is invoked only
once throughout the entire tree.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
