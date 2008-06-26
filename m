Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYFZFmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYFZFmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYFZFmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:42:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYFZFmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:42:09 -0400
Date: Wed, 25 Jun 2008 22:39:59 -0700
From: Greg KH <greg@kroah.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
Message-ID: <20080626053959.GA25731@kroah.com>
References: <485E984B.1030306@aitel.hist.no> <20080622184253.GB18502@kroah.com> <20080622210113.9971488b.akpm@linux-foundation.org> <48622546.6070505@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48622546.6070505@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 01:00:22PM +0200, Helge Hafting wrote:

> The problem is triggered by bending the USB cable - likely a cable fault. 
> Sometimes I merely get a plain USB device disconnect. (This also
> aborts my gps logging as the gps tend to reconnect to /dev/ttyUSB1 instead 
> of /dev/ttyUSB0, but I guess that is a userland issue, not a kernel 
> problem. Or is this a race condition?)

That is because your userspace program still has ttyUSB0 open, so it
creates the next valid device, ttyUSB1.  There is no way to connect the
new device to the old one as it has no idea it should do so.

Flaky hardware connections are not nice on drivers at times, although we
should not be crashing :)

We are probably just not handling the fact that the device is still open
properly, although I thought all of those errors were long since fixed,
perhaps the tty layer changes are now showing other inadequacies of the
usb-serial core up...

Those debug logs would be most helpful in tracking this down.

thanks,

greg k-h
