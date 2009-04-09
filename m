Return-Path: <linux-kernel-owner+w=401wt.eu-S934915AbZDIOzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbZDIOzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934760AbZDIOzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:55:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934751AbZDIOzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:55:14 -0400
Date: Thu, 9 Apr 2009 07:47:36 -0700
From: Greg KH <gregkh@suse.de>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: The problems for driver module loading
Message-ID: <20090409144736.GA7351@suse.de>
References: <fad7ab4fac82c.ac82cfad7ab4f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fad7ab4fac82c.ac82cfad7ab4f@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 04:39:52PM +0800, fangxiaozhi 00110321 wrote:
> Dear All:
> 
> I am sorry, I want to know is there the feature of priority (PRI) for
> kernel driver loading in Linux, such as in Windows or Mac OS.

No, Linux does not have that.  It is really a "first driver
loaded/linked that wants to grab the driver, wins."

> I develop an independent ECM driver for our standard ECM ether device.
> And then I install it on some Linux system, such as OpenSUSE 11.0 or
> Fedora 10. 

Why a separate driver?  Why not just modify the existing one?

> But in these systems, they also have a built-in ECM driver
> cdc_ether.ko. So, while I plug in our device, then the system often
> attaches cdc_ether.ko driver for our device, but not attaching ours.
> 
> Because cdc_ether.ko driver can not support our QMI protocol, so we
> want the Linux system can always attach our driver to our device, but
> not cdc_ether.ko driver.
> 
>    How can I do for this? 

Add a blacklist entry in the cdc_ether driver.

Or, from userspace, unbind the device from cdc_ether and bind it to your
device.  This can easily be done in userspace through sysfs using a
script triggered from udev.

Do you have a pointer to your driver anywhere?

thanks,

greg k-h
