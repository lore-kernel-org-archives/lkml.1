Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXKAOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXKAOrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXKAOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:47:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33181 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751389AbXKAOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:47:25 -0400
Date: Thu, 1 Nov 2007 10:47:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven King <sfking@fdwdc.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
In-Reply-To: <200710312225.44210.sfking@fdwdc.com>
Message-ID: <Pine.LNX.4.44L0.0711011044400.4146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Steven King wrote:

>   My TI eZ430 (MSP-FET430UIF JTAG Tool) usb dongle works fine with 2.6.23.1 
> and earlier, but doesn't work with 2.6.24-rc1; the ti_usb_3410_5052 module is 
> loaded but the device descriptor is bogus, reporting only a single 
> configuration, whereas in 2.6.23.1 it reports 2 configurations, allowing one 
> to select the second configuration to get a serial port.
> 
> git bisect fingered this commit:
> 
> 063a2da8f01806906f7d7b1a1424b9afddebc443 "USB: serial core should respect 
> driver requirements"

Are you certain about this?  That commit could not possibly have 
changed the way the USB core evaluates the device or configuration 
descriptors.  In fact, the commit affects only code in the usb-serial 
driver, which doesn't get loaded until well after the descriptors have 
been parsed.

Alan Stern

