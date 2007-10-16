Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbXJPXY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbXJPXY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760562AbXJPXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:24:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbXJPXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:24:49 -0400
Date: Tue, 16 Oct 2007 16:23:50 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: jens.axboe@oracle.com, kay.sievers@vrfy.org, rjw@sisk.pl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Message-ID: <20071016232350.GB24827@kroah.com>
References: <20071016204238.GA1093@kroah.com> <20071016205053.GI9942@kernel.dk> <20071016213730.GB21815@kroah.com> <20071016.153248.95506316.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016.153248.95506316.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 03:32:48PM -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Tue, 16 Oct 2007 14:37:30 -0700
> 
> > Kay, are we doing something wrong in userspace when renaming wireless
> > devices such that we can overlap names?
> 
> It does it for all network devices, I see this ugly message on every
> single system I have from Fedora foo to RHEL foo to ubuntu foo to
> debian foo.
> 
> udev simply applies the MAC address to device name rules blindly, it
> doesn't check if the device already has the desired name already

Ugh :(

> It's been like this forever, and since userland has been doing it for
> so long, you can't warn on this there is too much established
> practice.  Expecting people to install "fixed" udev is not an
> acceptable answer, the warning is a regression and therefore you'll
> have to remove the kernel warning for this case and live with this
> issue essentially forever.

Nope, I guess we will have to take out the check (or put it under the
kobject debugging flag), unless Kay has any other ideas...

thanks,

greg k-h
