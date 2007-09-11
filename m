Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXIKBKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXIKBKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbXIKBKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:10:23 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:25829 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbXIKBKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:10:22 -0400
Date: Mon, 10 Sep 2007 19:09:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ECC and DMA to/from disk controllers
In-reply-to: <fa.qDlrttL6xIyU0yqEbWvsJiyy5tU@ifi.uio.no>
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Message-id: <46E5EAB9.9020504@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.qDlrttL6xIyU0yqEbWvsJiyy5tU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce Allen wrote:
> Dear LKML,
> 
> Apologies in advance for potential mis-use of LKML, but I don't know 
> where else to ask.
> 
> An ongoing study on datasets of several Petabytes have shown that there 
> can be 'silent data corruption' at rates much larger than one might 
> naively expect from the expected error rates in RAID arrays and the 
> expected probability of single bit uncorrected errors in hard disks.
> 
> The origin of this data corruption is still unknown.  See for example 
> http://cern.ch/Peter.Kelemen/talk/2007/kelemen-2007-C5-Silent_Corruptions.pdf 
> 
> 
> In thinking about this, I began to wonder about the following.  Suppose 
> that a (possibly RAID) disk controller correctly reads data from disk 
> and has correct data in the controller memory and buffers.  However when 
> that data is DMA'd into system memory some errors occur (cosmic rays, 
> electrical noise, etc).  Am I correct that these errors would NOT be 
> detected, even on a 'reliable' server with ECC memory?  In other words 
> the ECC bits would be calculated in server memory based on incorrect 
> data from the disk.

It depends where the data got corrupted. Normally transfers over the PCI 
or PCI Express bus are protected by parity (or CRC or something, I 
assume on PCI-E) so errors there would get detected. This is quite rare 
unless the motherboard or expansion card is faulty or badly designed 
with timing problems.

However, it's conceivable that data could get corrupted inside the 
controller, or inside the chipset. This seems quite rare however, except 
in the presence of design flaws (like some VIA southbridges that had 
nasty problems with losing data if PCI bus masters kept the CPU off the 
PCI bus too long, which we have to work around).

> 
> The alternative is that disk controllers (or at least ones that are 
> meant to be reliable) DMA both the data AND the ECC byte into system 
> memory. So that if an error occurs in this transfer, then it would most 
> likely be picked up and corrected by the ECC mechanism.  But I don't 
> think that 'this is how it works'.  Could someone knowledgable please 
> confirm or contradict?

I don't know any controller that works in this way. This would greatly 
increase CPU overhead since the CPU would need to perform this CRC 
calculation.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

