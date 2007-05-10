Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbXEJPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbXEJPES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXEJPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:04:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39836 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbXEJPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:04:07 -0400
Date: Thu, 10 May 2007 08:05:01 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
	released
Message-ID: <20070510150501.GA22752@kroah.com>
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com> <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com> <46432FFD.1040304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46432FFD.1040304@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 04:45:17PM +0200, Tejun Heo wrote:
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

As I don't think we should be adding your sysfs rework to 2.6.22 just
yet, any objections to me just sending this to Linus for 2.6.22 and
waiting on your previous one for when the whole sysfs rework patchset is
sent?

thanks,

greg k-h
