Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZKYXIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZKYXIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbZKYXIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:08:04 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:48425 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549AbZKYXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:08:03 -0500
Date: Wed, 25 Nov 2009 18:07:51 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christoph Hellwig <hch@lst.de>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical
 temperature
In-reply-to: <20091125221332.GA24173@lst.de>
Message-id: <alpine.LFD.2.00.0911251804230.9675@localhost.localdomain>
References: <20091125102857.GA28310@lst.de>
 <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
 <20091125221332.GA24173@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Christoph Hellwig wrote:

> On Wed, Nov 25, 2009 at 04:56:19PM -0500, Len Brown wrote:
> > "thermal.nocrt=1" will disable the actual shutdown -- but you'll
> > still get the warning -- which might be helpful.  "thermal.crt=105"
> > would override all critical trip points to be 105, for example,
> > but otherwise not change any behaviour.
> 
> Well, I suspect the warnings are there for a reason, e.g. with 2.6.32-rc
> I also hear the fan regularly while I've almost never done before.  So I
> guess the reason for it is that throtteling might have problems.

Does the fan noise go away when you revert back to an older kernel?
(if no, unclog your fan:-)

> > > I've done some attempts at bisecting it, but for most of the 2.6.32-rc
> > > series the system crashes during boot in ACPI code with a backtrace
> > > longer than the screen can display.
> > 
> > Hmm, I don't have a T500, but I've not seen such crashes during -rc.
> > Please send along your .config
> 
> Attached.

can you send the .config that you boot on the (Thinkpad?) T500?
you sent a PPC64 config.

> > Do you still get them when disabling the thinkpad-acpi driver?
> 
> I'll try.  This is my main work machine (and I'm travelling right now),
> so any sort of bisection and testing will take a while..
> 
> > Probably the most interesting place to bisect is drivers/acpi/ec.c
> > 
> > If you can send along the dmesg from the recent failing kernel,
> 
> That is failing to boot, or the 2.6.32-rc8 kernel?  No chance to capture
> the dmesg of the one failing to boot unfortunately..

I thought that rc8 boots, but overheats - can you capture
the dmesg before it overheats?

> > plus the output from "grep . /proc/acpi/thermal_zone/*/*"
> > that may be helpful.
> 
> brick:~# grep . /proc/acpi/thermal_zone/*/*
> /proc/acpi/thermal_zone/THM0/cooling_mode:<setting not supported>
> /proc/acpi/thermal_zone/THM0/polling_frequency:<polling disabled>
> /proc/acpi/thermal_zone/THM0/state:state:                   ok
> /proc/acpi/thermal_zone/THM0/temperature:temperature:             46 C
> /proc/acpi/thermal_zone/THM0/trip_points:critical (S5):           127 C
> /proc/acpi/thermal_zone/THM1/cooling_mode:<setting not supported>
> /proc/acpi/thermal_zone/THM1/polling_frequency:<polling disabled>
> /proc/acpi/thermal_zone/THM1/state:state:                   ok
> /proc/acpi/thermal_zone/THM1/temperature:temperature:             49 C
> /proc/acpi/thermal_zone/THM1/trip_points:critical (S5):           100 C
> /proc/acpi/thermal_zone/THM1/trip_points:passive:                 96 C:
> tc1=5 tc2=4 tsp=600 devices=CPU0 CPU1 

This part looks normal.

thanks,
-Len

