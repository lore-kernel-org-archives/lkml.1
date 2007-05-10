Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbXEJPwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbXEJPwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXEJPwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:52:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58694 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754788AbXEJPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:52:33 -0400
Date: Thu, 10 May 2007 11:52:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Greg KH <greg@kroah.com>, Chris Rankin <rankincj@yahoo.com>,
       <linux-usb-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
 released
In-Reply-To: <46432FFD.1040304@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0705101150100.3498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Tejun Heo wrote:

> Currently, devt_attr for the "dev" file is freed immediately on device
> removal, but if the "dev" sysfs file is open when a device is removed,
> sysfs will access its attribute structure for further access including
> close resulting in jumping to garbled address.  Fix it by postponing
> freeing devt_attr to device release time.
> 
> Note that devt_attr for class_device is already freed on release.
> 
> This bug is reported by Chris Rankin as bugzilla bug#8198.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Chris Rankin <rankincj@yahoo.com>
> ---
> Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
> seem to be included in 2.6.22, this should be included in linus#master
> too (applies well there as well).

Although sysfs-immediate-disconnect may not be included in 2.6.22, the old 
attribute-orphan code by Oliver Neukum is present there and also in 
2.6.21.  Shouldn't that suffice?

Alan Stern

