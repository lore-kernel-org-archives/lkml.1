Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbXHCHzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbXHCHzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXHCHzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:55:32 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:56745 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXHCHzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:55:31 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 09:57:45 +0200
User-Agent: KMail/1.9.7
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de> <20070803014756.GA10392@srcf.ucam.org>
In-Reply-To: <20070803014756.GA10392@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030957.46320.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 August 2007 schrieb Matthew Garrett:
> > Also, we have udev rules for SANE that disables their autosuspend
> > settings, which handles the majority of the devices we have seen with
> > problems.
> 
> Several printers seem to have the issue as well, and the blacklist seems 
> to contain some odd miscellaneous devices like the Blackberry. The main

Then make autosuspend support for the printer driver a config option.
This is not a reason to change the core usb code. The core code needs
to be involved only for device that are driven through usbfs. The major types
are:

- scanners
- PTP devices
- OBEX

Scanners are covered by SANE's latest CVS
PTP are a class and could be covered by a single udev rule
Obex is comm, so the patch wouldn't help.

> concern I have is that kernel developers just don't tend to be the sort 
> of people that use webcams, printers or scanners, so we're relying on 
> normal users to go to the effort of reporting that their device has 
> stopped working.

Kernel developers are a diverser lot than you think ;-)
We don't enable autosuspend in drivers we can't test, except where
the lack of a kernel driver forces us to use a broad swipe. Printers
were tested, too, and most printers seem to work.

	Regards
		Oliver
