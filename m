Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXKCXXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXKCXXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXKCXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:23:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36169 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbXKCXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:23:13 -0400
Date: Sat, 3 Nov 2007 16:14:03 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: device struct bloat
Message-ID: <20071103231403.GB6161@kroah.com>
References: <20071103124823.6059640e@shemminger-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103124823.6059640e@shemminger-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 12:48:23PM -0700, Stephen Hemminger wrote:
> The sizeof(struct device) is way too big, especially in the network device case.
> We want to support 1000's of device's and the change from class_device to
> net_device has caused needless bloat.
> 
> sizeof(struct device) = 272
> sizeof(struct class_device) = 92
>   * not the class_id in class_device could also be removed or changed to
>      a ptr, since it is redundant for net_devices.

I agree that struct device is bigger than perhaps it should be (Kay is
working on getting rid of the bus_id field and we both just trimmed down
the base kobject by about 20 bytes) but is this really a problem that is
noticable by anyone?

I'm all for saving memory, but 1000's of struct devices is not anything
that the kernel should even notice.  s390 machines create tens of
thousands of these all the time, and they are severly memory limited,
with no apparent problem.

And I'm guessing that embedded systems would not be the ones that would
be creating 1000's of network devices, right?  Are these virtual devices
or backed by real, physical devices?

If it is an issue, we can start to work on slimming the structure down.
At first glance, I'm sure we can save memory by just rearanging the
fields to get rid of some structure padding that I'm sure is there.

After that, I'm sure we can push a lot of other fields out into a
separate structure to handle if the device is "virtual" or not, which
would let us drop a bunch of the dma and other resource-type things.

thanks,

greg k-h
