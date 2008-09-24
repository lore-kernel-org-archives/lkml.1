Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYIXJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYIXJ6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYIXJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:58:05 -0400
Received: from mail.transmode.se ([83.241.175.147]:28572 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYIXJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:58:04 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Paul Mundt <lethal@linux-sh.org>
Cc: hjk@linutronix.de, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080924093551.GB7591@linux-sh.org>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Wed, 24 Sep 2008 11:57:59 +0200
Message-Id: <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 18:35 +0900, Paul Mundt wrote:
> On Wed, Sep 24, 2008 at 11:21:33AM +0200, Joakim Tjernlund wrote:
> > As far as I can see there isn't a way to name the /dev/uio%d device file
> > to something more useful, is that so?
> > I would like to name the device file from within the kernel so I can
> > find the correct device from userspace.
> > The very least is to control the minor(%d) number.
> > 
> You have a couple of options for this:
> 
> 	- the 'name' sysfs entry for each of the uio devices, which
> 	  corresponds to the uio device name.
> 	- extracting the relevant data from things like 'lsuio'.
> 	- hooking in the pretty mame through udev to create an alias.

Right, but I want to do it from within the kernel when I create the
device because that the only place I truly know what HW the uio maps to.

I found that this works:
 struct uio_info *info,
 struct uio_device *idev;

 idev = info->uio_dev;
 device_rename(idev->dev, "irq4");

but then I have to copy the private uio_device struct from uio.c
Is there a better way to get at idev->dev?

 Jocke

