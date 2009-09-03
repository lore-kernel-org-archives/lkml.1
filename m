Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZICAx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZICAx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZICAxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:53:25 -0400
Received: from kroah.org ([198.145.64.141]:56566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZICAxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:53:24 -0400
Date: Wed, 2 Sep 2009 17:50:51 -0700
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem starting the input interrupt pipe on the G13
Message-ID: <20090903005051.GA6733@kroah.com>
References: <a571ebde1bc221dd250a03e9fb33ed66.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a571ebde1bc221dd250a03e9fb33ed66.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 03:25:50PM -0600, Rick L. Vinyard, Jr. wrote:
> Hello,
> 
> I'm still working on the G13 driver, but I've run into a problem with the
> interrupt in pipe. In essence, I can't figure out how to get it started.
> 
> The driver can be found at:
> http://g13.svn.sourceforge.net/viewvc/g13/driver/trunk/
> 
> I think the root of the problem lies in the fact that the G13 usage page
> is 0x00 (undefined). The output and feature reports seem to be working
> fine to set the backlight color, the LCD image and the leds on the 'M'
> keys.
> 
> However, nothing seems to be happening with the input report (there is
> only one input report type on endpoint address 0x81 that contains the
> joystick and key values).
> 
> The problem is getting the input pipe started. I grepped through the other
> drivers in the hid directory and I couldn't find any that had to
> explicitly start the input interrupt.

Have you just submitted an interrupt urb?

That should be all that is needed, when the device has data, it will
return with it if your urb is pending.

thanks,

greg k-h
