Return-Path: <linux-kernel-owner+w=401wt.eu-S935129AbZKYV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbZKYV4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935118AbZKYV4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:56:20 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:36391 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935119AbZKYV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:56:16 -0500
Date: Wed, 25 Nov 2009 16:56:19 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christoph Hellwig <hch@lst.de>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical
 temperature
In-reply-to: <20091125102857.GA28310@lst.de>
Message-id: <alpine.LFD.2.00.0911251647000.3950@localhost.localdomain>
References: <20091125102857.GA28310@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Christoph Hellwig wrote:

> I recently upgraded my Thinkpad T500 from Linux 2.6.31 to Linux
> 2.6.32-rc (first -rc7 but I've also tried with -rc6 and -rc8) and when
> putting load on it, e.g. by building a kernel tree.  It shuts down soon
> with the
> 
> 	Critical temperature reached (%ld C), shutting down.\n"
> 
> printk from drivers/thermal/thermal_sys.c, where the temperature is
> usually 100C or slightly above.  The system is a Lenovo Thinkpad T500
> with a Intel Core 2 Dueo T9600 running a 32 bit kernel.

"thermal.nocrt=1" will disable the actual shutdown -- but you'll
still get the warning -- which might be helpful.  "thermal.crt=105"
would override all critical trip points to be 105, for example,
but otherwise not change any behaviour.

> I've done some attempts at bisecting it, but for most of the 2.6.32-rc
> series the system crashes during boot in ACPI code with a backtrace
> longer than the screen can display.

Hmm, I don't have a T500, but I've not seen such crashes during -rc.
Please send along your .config
Do you still get them when disabling the thinkpad-acpi driver?

Probably the most interesting place to bisect is drivers/acpi/ec.c

If you can send along the dmesg from the recent failing kernel,
plus the output from "grep . /proc/acpi/thermal_zone/*/*"
that may be helpful.

thanks,
-Len

