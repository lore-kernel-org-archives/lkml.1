Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbXBVGbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbXBVGbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXBVGbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:31:39 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20992 "EHLO
	pd5mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXBVGbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:31:39 -0500
Date: Thu, 22 Feb 2007 00:27:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-reply-to: <fa.G4k+9fbJDE0N5pygu22mRYU6gfE@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, ceztko@gmail.com, htejun@gmail.com
Message-id: <45DD37E9.7010303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Fk9DulKIUBewV0V2B72MDzbelmU@ifi.uio.no>
 <fa.RCbhxyLCSR5f65HWabMGmxZNYQ4@ifi.uio.no>
 <fa.G4k+9fbJDE0N5pygu22mRYU6gfE@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Alan wrote:
>> Stick some printk calls in drivers/ata/libata-eh.c in ata_eh_suspend, or
>> turn on all the ATA debug and shutdown, the code should issue a cache
>> flush followed by a standbynow1 command for each disk.
>>
>> Alan
> 
> I believe it runs on suspend, but we don't run that code on normal 
> shutdown, do we?
> 
> Tejun Heo had a patch for sd that could (optionally) trigger a START 
> STOP UNIT command to spin the disk down after synchronizing the cache 
> before shutdown, but I haven't heard anything of it lately..

And yes, this is something we need to deal with. I don't think that 
disks that use contact start-stop heads care so much, but disks that use 
load-unload heads (like most laptop drives, it seems) generally quote a 
much lower cycle lifetime for "emergency unloads" caused by power loss 
than by normal unloads done while power is still applied. It's important 
enough that in some cases, like the Compaq X1000-series laptop I have, 
the BIOS appears to have a power button handler that spins down the 
drive before power-down when the power button is pressed and an ACPI OS 
isn't running. (Holding the button down when an ACPI OS is running just 
forces the power off, then you get the clunk from the drive..)

Windows XP (and even as far back as Windows 98) get this right, surely 
we can do as well :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

