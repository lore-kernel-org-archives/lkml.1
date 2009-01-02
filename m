Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZABOJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZABOJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZABOIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:08:51 -0500
Received: from eazy.amigager.de ([213.239.192.238]:35092 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZABOIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:08:51 -0500
Date: Fri, 2 Jan 2009 15:08:45 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
	be unplugged safely
Message-ID: <20090102140845.GA25400@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090101160343.GA4278@thyme.bj.intel.com> <20090102095643.GB17103@x61> <20090102140023.GC4833@thyme.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102140023.GC4833@thyme.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 22:00:23 +0800, Yan Li wrote:
> On Fri, Jan 02, 2009 at 10:56:43AM +0100, Tino Keitel wrote:
> > With a WD My Passport drive (2,5"), I need to use sg_start --stop --pc=3
> > to stop the disk before unplugging it. Maybe this works with your
> > drive, too.  This is also required by some Firewire hard disks.  Maybe
> > the eject command should be extended to use this method, as it is used
> > also by HAL to eject hotplug devices.
> 
> Hum...  I grepped my hal and hal-info packages but haven't found any
> scripts using `sg_*'. I'm using hal package 0.5.11-6 from Debian
> testing.

HAL uses /usr/bin/eject, which doesn't set the power condition (as
sg_start --pc=X does).  So eject (and HAL) doesn't work with disks that
require to set the power condition.

Just try sg_start --stop --pc=3 /dev/sdX to see if it works for you.

Regards,
Tino
