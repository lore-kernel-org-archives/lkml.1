Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYE3I0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYE3I0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYE3I0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:26:09 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:56585 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYE3I0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:26:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMOAPZWP0hV5NxaPGdsb2JhbAAIiFWJQwEBAQEtnE0
Message-ID: <483FBA1B.3020505@bredband.net>
Date: Fri, 30 May 2008 10:26:03 +0200
From: Andrew Henry <adhenry@bredband.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.25: sata_sil freezes, hard resets port.
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>ATA drives are supposed to wake up from standby on command issue and
>>from sleep on reset.  Does the drive spin up while sata_sil is trying
>>to reset the port?  Also, please post the result of 'hdparm -I
>>/dev/sdX' where sdX is the offending drive.
>>-- 
>>tejun


Here is the output from hdparm -I /dev/sdb.  The output is the same for both drives.

I just want to re-state that it's not just when drives spindown.  Happens on hotplug or cold boot also.


As for what happens when I try to access the drives when they have spun down:

- drives are asleep
- i run fdisk -l
- drive on port 1 spins up and LED for that port lights up
- it waits 60s then the LED *should* turn off, but many times, at this point the port will hang: LED is always on
- LED on port 2 lights up, drive spins up, after 60s fdisk reports full output for drives and returns to prompt
- port 1 is still hung.  I remove cable and plug it in again, no effect
- fdisk -l makes port 2 LED flash briefly and reports one  of the eSATA drives connected. port 1 LED does not flash
- unplug port 1 cable and disconnect power to drive; power drive and connect cable: drive is redetected and fdisk reports 2 drives

it is not always the same port that hangs, it seems random.

/dev/sdb:

ATA device, with non-removable media
	Model Number:       WD My Book                              
	Serial Number:      WD-WCASU0206873
	Firmware Revision:  01.01B01
Standards:
	Used: ATA/ATAPI-6 T13 1410D revision 1 
	Supported: 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  976773168
	device size with M = 1024*1024:      476940 MBytes
	device size with M = 1000*1000:      500107 MBytes (500 GB)
Capabilities:
	LBA, IORDY(cannot be disabled)
	Queue depth: 1
	Standby timer values: spec'd by Vendor, with device specific minimum
	R/W multiple sector transfer: Max = 1	Current = 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	   *	Power Management feature set
	   *	Write cache
	   *	48-bit Address feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART self-test
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	SATA-II signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)

--andrew
