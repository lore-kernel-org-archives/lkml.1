Return-Path: <linux-kernel-owner+w=401wt.eu-S965699AbXBHXum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699AbXBHXum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXBHXum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:50:42 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36442 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965699AbXBHXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:50:41 -0500
Subject: Re: Git backlight subsystem tree
From: Richard Purdie <rpurdie@rpsys.net>
To: Greg KH <greg@kroah.com>
Cc: James Simmons <jsimmons@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
In-Reply-To: <20070208212314.GA21165@kroah.com>
References: <1170901826.5859.2.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
	 <1170957595.5849.11.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
	 <20070208212314.GA21165@kroah.com>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 23:50:23 +0000
Message-Id: <1170978623.5849.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, 2007-02-08 at 13:23 -0800, Greg KH wrote:
> On Thu, Feb 08, 2007 at 06:32:02PM +0000, James Simmons wrote:
> > I CC Greg to explain. The backlight class didn't go away. The way it is 
> > handled is different.
> 
> Have a pointer to the patch so I can help explain better?

You've been cc'd on the proposed patch a couple of times in this thread
so it should be in your mailbox now.

> As a short summary, 'struct class_device' is going away.  Using a
> 'struct device' in its place is what the conversion should have just
> done, no functionality change otherwise.

The backlight class is drivers/video/backlight/backlight.c and if I
understand things correctly what shows up in sysfs changes.

At the moment (as I understand the code which could be wrong), the
backlight functionality is tagged onto an existing device. Taking
drivers/video/backlight/corgi_bl.c as an example, the corgi_bl device
exists under /sys/devices/platform/corgi_bl with an associated struct
device. The backlight code then appends some magic to this to link in
some class attributes that show up under /sys/class/backlight. There is
only ever one device.

By replacing class_device_register() with device_create(), the proposed
patch appears to generate a second struct device with the original as
its parent. I'm not sure where it appears in /sys/devices? Having
another full blown struct device around makes me uneasy as wherever it
appears, we only have one device, not two.

If I had some kind of platform device which had an LED, backlight and
say battery component and registered with the three appropriate classes
would that mean four struct devices? Where under /sys/devices do they
each appear?

Also, it was mentioned that a parent struct device is a requirement and
this isn't the case for all backlight users. I think this constraint on
device_create has been removed in more recent code though? 

Richard

