Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYHRWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYHRWAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYHRWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:00:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYHRWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:00:19 -0400
Date: Mon, 18 Aug 2008 13:46:01 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080818204601.GA14374@kroah.com>
References: <20080818202100.GE23155@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818202100.GE23155@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:21:00PM -0600, Alex Chiang wrote:
> Create convenience symlinks in sysfs, linking slots to devices
> and functions, and vice versa. These links make it easier for
> users to figure out which devices actually live in what slots.
> 
> The device symlink points to the device's first function.
> 
> For example:
> 
> sapphire:/sys/bus/pci/slots # ls
> 1  10  2  3  4  5  6  7  8  9
> 
> sapphire:/sys/bus/pci/slots # ls -l 3
> total 0
> -r--r--r-- 1 root root 65536 Aug 18 14:10 address
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 device -> ../../../../devices/pci0000:23/0000:23:01.0
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 -> ../../../../devices/pci0000:23/0000:23:01.0
> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 -> ../../../../devices/pci0000:23/0000:23:01.1
> 
> sapphire:/sys/bus/pci/slots # ls -l 3/device/slot
> lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/device/slot -> ../../../bus/pci/slots/3
> 
> The original form of this patch was written by Matthew Wilcox,
> but did not have links from the sysfs slots/ directory pointing
> back at devices and functions.

As you are adding new sysfs files/symlinks, please document them in
Documentation/ABI.

thanks,

greg k-h
