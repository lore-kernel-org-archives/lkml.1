Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXHOPdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXHOPdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbXHOPdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:33:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38246 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760697AbXHOPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:33:24 -0400
Date: Wed, 15 Aug 2007 11:33:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Florin Iucha <florin@iucha.net>, Greg KH <gregkh@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <46C313B3.4030700@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708151128530.3895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Tejun Heo wrote:

> Alan Stern wrote:
> > I think we can simply remove the error message.  There's no obvious 
> > reason why sysfs_remove_bin_file() should complain about attempts to 
> > remove a nonexistent file; sysfs_remove_file() doesn't.
> > 
> > This patch will get rid of the annoying error messages.  It won't do 
> > anything about your keyboard's tendency to spontaneously stop working, 
> > alas.
> 
> Agreed but I think sysfs_remove_bin_file() should relay the return value
> from sysfs_has_and_remove() to the caller.

Perhaps.  But none of

	sysfs_remove_one()
	sysfs_remove_subdir()
	sysfs_remove_dir()
	sysfs_remove_file()
	sysfs_remove_file_from_group()
	sysfs_remove_group()
	sysfs_remove_link()

return a value.  Why should sysfs_remove_bin_file() be different?  And 
what callers would pay attention to the return value?

Alan Stern

