Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbYBNUzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbYBNUzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbYBNUzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:55:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbYBNUzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:55:02 -0500
Date: Thu, 14 Feb 2008 12:52:24 -0800
From: Greg KH <greg@kroah.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214205224.GC17277@kroah.com>
References: <47B30291.2040905@davidnewall.com> <200802141255.22048.gene.heskett@gmail.com> <20080214193731.3c36acb0@core> <200802141504.41991.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802141504.41991.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 03:04:41PM -0500, Gene Heskett wrote:
> On Thursday 14 February 2008, Alan Cox wrote:
> >> byte of a packet is being thrown away about .1% of the time for the
> >> pl2303, but I'm not sure if the FTDI driver still suffers from a similar
> >> rash.  I
> >
> >A 20 byte low speed message is too small for flow control to account for
> >it.
> 
> Where then could the first byte go?  Note I'm not fussing about flow controls 
> per sei, so the subject line maybe needs to be adjusted, but they obviously 
> work well enough that a multimegabyte transfer to my printer works very well, 
> but about usb trying to entirely replace serial here.  There does seem to be 
> a problem but I'm not 100% positive where it is in the chain of a usb packets 
> travels.  What I've observed, with hidraw I think it was, is that the 
> first 'wake up' byte incoming didn't seem to be there.

I have not seen this kind of error in years, why have you not reported
it?

Can you enable debugging in the pl2303 driver with a simple:
	modprobe pl2303 debug=1
or when the driver is running with:
	echo 1 > /sys/module/pl2303/parameters/debug

That way you can see the data flowing through the device.  If the host
sends it to the device, perhaps your device is just dropping it somehow?

These pl2303 devices are really cheap, there are lots of different
variations of them, and none of them are documented at all.  We might be
missing some kind of interaction here, but in my tests, I have not had
any lost data.

Are you sure your userspace program isn't constantly setting the line
settings?  We have seen instances where the device does get confused and
resets itself if that happens a lot.  That was just fixed in the last
kernel release.

thanks,

greg k-h
