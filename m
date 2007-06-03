Return-Path: <linux-kernel-owner+w=401wt.eu-S1764199AbXFCGjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764199AbXFCGjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXFCGjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:39:31 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61242 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXFCGja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:39:30 -0400
Date: Sun, 03 Jun 2007 00:39:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Ignore partition table on device
In-reply-to: <fa.vZzvuMSQgFqVdMg4HFBBvE7gt1s@ifi.uio.no>
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Jonathan Schleifer <js@h3c.de>, linux-kernel@vger.kernel.org
Message-id: <46626228.5040705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4wKuD5mNHMp1umbfR+OImkVtgUw@ifi.uio.no>
 <fa.vZzvuMSQgFqVdMg4HFBBvE7gt1s@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andries Brouwer wrote:
> I agree that the current behaviour of touching all devices seen
> at boot time is rather undesirable. It adds twenty seconds to the
> boot time of my machine, where Linux tries to read nonexisting media
> in the on-board usb storage devices, starting error-recovery when that
> fails, etc. (These days it also seems that even when no errors occur
> everything is done twice - maybe a libata bug, I have not looked,
> attached a dmesg fragment.) And the unasked-for guessing has caused
> a thin trickle of problems for over ten years.
> 
> But this patch is not really an improvement.
> It allows you to tell about a single device that the kernel should
> not try to find a partition table there, because even if it finds
> something that resembles a partition table, it would be mistaken.
> The general case is that one wants to say the same thing about
> several devices - if you ask me, about all devices, except possibly
> for an explicitly specified boot device.
> 
> It should be userspace that directs the kernel to probe a device.
> It should be udev or some such program that tells the kernel to
> look for a partition table on a newly found device. Perhaps even
> for a partition table of known type. Or maybe userspace does the
> looking itself, using partx or so - sometimes userspace knows better
> what to expect.
> 
> Maybe there already is such an option in the vanilla kernel,
> but if there isnt't it should be added: noautoreadpt.
> 
> Andries
> 
> "done twice":
> [   26.505536] SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
> [   26.505584] sda: Write Protect is off
> [   26.505616] sda: Mode Sense: 00 3a 00 00
> [   26.505630] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   26.505713] SCSI device sda: 625142448 512-byte hdwr sectors (320073 MB)
> [   26.505755] sda: Write Protect is off
> [   26.505787] sda: Mode Sense: 00 3a 00 00
> [   26.505801] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   26.505844]  sda: sda1 sda2 < sda5 >
> [   26.535025] sd 0:0:0:0: Attached scsi disk sda
> 
> "done twice":
> [   25.839447] scsi6 : SCSI emulation for USB Mass Storage devices
> [   30.844107] sd 6:0:0:0: Attached scsi removable disk sdb
> [   42.519502] sdb : READ CAPACITY failed.
> [   42.770997] scsi7 : SCSI emulation for USB Mass Storage devices
> [   48.024083] sd 7:0:0:0: Attached scsi removable disk sdb
> [   49.326683] sdb : READ CAPACITY failed.
> [   49.331174] scsi 7:0:0:0: rejecting I/O to dead device
> 
> There is nothing wrong with sdb (and sdc, sdd, sde).
> They are just USB card readers without media.

This isn't reading the partition table, it's sd trying to determine what 
the size of the disk is. Presumably what's happening there is that card 
reader is not responding as the kernel expects it to. If there's no card 
in the reader, it should be returning an error immediately indicating 
"not ready", but something here causes it to take 12 seconds and then 
fail the command..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

