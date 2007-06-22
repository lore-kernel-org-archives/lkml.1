Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbXFVACV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbXFVACV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXFVACG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:02:06 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:41425 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbXFVACE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:02:04 -0400
Date: Thu, 21 Jun 2007 18:00:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
In-reply-to: <fa.qwrQSldd4OzDT6RgWE5P1BD9PJw@ifi.uio.no>
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Message-id: <467B1100.4000401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8+Qu4ZH2B8PP3bRaZ5LNdUcsFIQ@ifi.uio.no>
 <fa.X6rjOVHT6SoOzt6SHEJROeRgf98@ifi.uio.no>
 <fa.qwrQSldd4OzDT6RgWE5P1BD9PJw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Rabbitson wrote:
> H. Peter Anvin wrote:
>> Peter Rabbitson wrote:
>>> I have captured dmesg output without mem[5], with mem=3900M[6] and
>>> mem=2048M[7].
>>>
>>
>> What does /proc/mtrr look like in the two cases?
>>
> 
> Identical for mem=3900 and without it.
> 
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1
> reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1
> reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1
> reg05: base=0xf8000000 (3968MB), size=  32MB: write-back, count=1

Looks like another case of bad MTRRs on an Intel motherboard? The BIOS 
is marking only memory up to 4000MB as cacheable, but the actual memory 
extends up to about 4031MB. Therefore anything that accesses the top 
31MB of memory will run very slow.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

