Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXHVFn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXHVFn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbXHVFnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:43:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:51853 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXHVFnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:43:20 -0400
Date: Tue, 21 Aug 2007 22:46:15 -0700
From: Greg KH <greg@kroah.com>
To: Nate <stoddarn@msoe.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Restricting CDC-ACM devices
Message-ID: <20070822054615.GA23336@kroah.com>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com> <20070821171018.C964B5F778@attila.bofh.it> <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 05:03:54PM -0500, Nate wrote:
> I would like to use the cdc-acm driver in the Linux kernel (2.6.22-rc1),
> but restrict the access to only my VID/PID devices.  Is there an easy way
> to do with without modifying cdc-acm.c?

Why do you not want to modify the driver?

> In a past prototype I made a simple wrapper driver for usb serial by
> adding my VID/PID numbers to the wrapper driver's id_table.  Then when
> that usb driver was accessed on connection, the driver just pointed to the
> usb_serial_* functions (probe, disconnect, etc).  I tried to do the same
> with the cdc-acm driver, but the cdc-acm driver's probe function was
> called before my driver's probe.  I noticed that the cdc-amc driver will
> attach when it detects the two CDC-ACM interfaces, so I removed the
> cdc-acm driver with "make menuconfig".  This didn't work because the
> cdc-acm functions I was attempting to call from my driver do not exist.

You can disconnect the device from the driver from userspace for any
device you just don't want to have connected by using the sysfs
bind/unbind files.  That doesn't require any kernel changes at all.

Why do you want to do this, what are you expecting to achieve with such
a change?

thanks,

greg k-h
