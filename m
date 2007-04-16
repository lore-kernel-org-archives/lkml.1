Return-Path: <linux-kernel-owner+w=401wt.eu-S1031009AbXDPWPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031009AbXDPWPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031021AbXDPWPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:15:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43997 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031009AbXDPWPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:15:20 -0400
Date: Mon, 16 Apr 2007 15:12:47 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] How should an exit routine wait for
	release() callbacks?
Message-ID: <20070416221247.GA9365@kroah.com>
References: <20070413162701.4e7342a9@gondolin.boeblingen.de.ibm.com> <Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704131049380.3407-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, just found this original thread, now Cornelia's patches make more
sense...

On Fri, Apr 13, 2007 at 11:24:58AM -0400, Alan Stern wrote:
> Tejun, it just occurred to me that you would be interested in this email 
> thread.  Just to bring you up to speed, here's the original question:
> 
> > I've got a module which registers a struct device.  (It represents a
> > virtual device, not a real one, but that doesn't matter.)

Wait, that's the issue right there.

Don't do that.

devices should be created by busses or the platform core, which owns the
release function for them.  Individual drivers should not create
devices.

Hm, but then, how would you ever unload a bus, as the same issue might
be there too...

Any specific code in the kernel you can point to that has this issue
today?

thanks,

greg k-h
