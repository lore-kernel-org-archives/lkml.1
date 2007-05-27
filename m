Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXE0OU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXE0OU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXE0OUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:20:20 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:35800 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbXE0OUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:20:19 -0400
Date: Sun, 27 May 2007 16:20:17 +0200
From: bert hubert <bert.hubert@netherlabs.nl>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at   least
Message-ID: <20070527142017.GA24564@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
	gregkh@suse.de
References: <20070526201854.GA20758@outpost.ds9a.nl> <1180233755.3131.4.camel@lov.localdomain> <20070527092546.GA10912@outpost.ds9a.nl> <1180275001.3131.28.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180275001.3131.28.camel@lov.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the separate class device. How does that help text sound?
> 
>   This option provides backward compatibility for systems where
>   usbfs is not mounted, and no udev rule like this exists:
>     SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", \
>       NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0644"

I'm mounting my Linus hat now, but the more I think about the
insta-deprecation of USB_DEVICE_CLASS, and killing lsusb in even a very
recent distribution release, I think this is an ABI or API change.

And we hate those.

So instead of papering this breakage over with cleverly worded help texts
that suggest a solution, how about we set USB_DEVICE_CLASS to 'y' by default
for a few more releases?

It would sure save a lot of lkml traffic on 'lsusb broke!'.

If this is unacceptable, please at least retain the word 'lsusb' somewhere
in the help text, so people have at least the chance to spot their (current)
need for USB_DEVICE_CLASS.

Perhaps:

"Some distributions need this feature for lsusb to work, unless the udev rule
 above is configured".

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
