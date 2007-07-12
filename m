Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbXGLBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbXGLBQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762224AbXGLBQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:16:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44598 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762093AbXGLBQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:16:06 -0400
Subject: Re: PCI devices power management, w/o sysfs? [Was: Re: Liunx power
	consumption on laptops ...]
From: Arjan van de Ven <arjan@infradead.org>
To: Richard Mittendorfer <delist@gmx.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070711144233.92a584fd.delist@gmx.net>
References: <468D4D82.8030009@linux.intel.com>
	 <20070711144233.92a584fd.delist@gmx.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 12 Jul 2007 09:15:56 +0800
Message-Id: <1184202956.2693.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 14:42 +0200, Richard Mittendorfer wrote:
> Greetings *!
> 
> I'm looking for a way to disable (PM low power mode) some devices I
> rarely/never use on my laptop to save some more power. With 2.6.17,
> IIRC, I was able to echo -n 2 > /sys/bus/pci/../power to put things
> into low power mode. (I don't know if it ever worked, but at least it
> looked like it did.)
> 
> ..-2.6.22(-ck1) w/ CONFIG_PM_SYSFS_DEPRECATED doesn't let me change this
> state. evident :) -----------------^^^^^^^^^^
> 
> Is there a proper way to do this (setpci, if I'd know the registers)?
> Is it gone/going inside drivers (like USB_SUSPEND) and I don't have to
> worry?
> 
> I currently don't load the modules in question - but I'm not sure if it
> helps, as they might already be powered on by PCI initialization/BIOS
> (/sys/bus/pci/../state cats "0").

the real solution is to do it right in the driver.
Using a sysfs "whack behind the drivers back" method is just a disaster
waiting to happen; it cannot be done reliable (for example, without
knowledge of what you're doing, an application that just whacks all may
whack devices that have hw quirks and cannot deal with this, etc etc).


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

