Return-Path: <linux-kernel-owner+w=401wt.eu-S966169AbXDCNM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966169AbXDCNM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966166AbXDCNM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:12:26 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:18528 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966165AbXDCNMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:12:25 -0400
Message-ID: <46125291.5080404@suse.de>
Date: Tue, 03 Apr 2007 22:11:45 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux@horizon.com
CC: cebbert@redhat.com, dan.j.williams@intel.com, jens.axboe@oracle.com,
       linux-ide@vger.kernel.org, linux-kernel@dale.us,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
References: <20070403130334.14799.qmail@science.horizon.com>
In-Reply-To: <20070403130334.14799.qmail@science.horizon.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
> linux@horizon.com wrote:
>>> Anyway, what's annoying is that I can't figure out how to bring the
>>> drive back on line without resetting the box.  It's in a hot-swap enclosure,
>>> but power cycling the drive doesn't seem to help.  I thought libata hotplug
>>> was working?  (SiI3132 card, using the sil24 driver.)
> 
>> Yeah, it's working but failing resets are considered highly dangerous
>> (in that the controller status is unknown and may cause something
>> dangerous like screaming interrupts) and port is muted after that.  The
>> plan is to handle this with polling hotplug such that libata tries to
>> revive the port if PHY status change is detected by polling.  Patches
>> are available but they need other things to resolved to get integrated.
>> I think it'll happen before the summer.
> 
>> Anyways, you can tell libata to retry the port by manually telling it to
>> rescan the port (echo - - - > /sys/class/scsi_host/hostX/scan).
> 
> Ah, thank you!  I have to admit, that is at least as mysterious as any
> Microsoft registry tweak.

Polling hotplug should fix this.  I thought I would be able to merge it
much earlier.  I apparently was way too optimistic.  :-(

>>> (H'm... after rebooting, reallocated sectors jumped from 26 to 39.
>>> Something is up with that drive.)
> 
>> Yeap, seems like a broken drive to me.
> 
> Actually, after a few rounds, the reallocated sectors stabilized at 56
> and all is working well again.  It's like there was a major problem with
> error handling.
> 
> The problem is that I don't know where the blame lies.

I'm pretty sure it's the firmware's fault.  It's not supposed to go out
for lunch like that even when internal error occurs.

-- 
tejun
