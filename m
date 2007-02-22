Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbXBVCe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbXBVCe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXBVCe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:34:57 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:3753 "EHLO
	pd5mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXBVCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:34:56 -0500
Date: Wed, 21 Feb 2007 20:34:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: High CPU usage with sata_nv
In-reply-to: <0c69abe94bbc69f652831a64ad77d0cb@digium.com>
To: Matthew Fredrickson <creslin@digium.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45DD0142.9020301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.1OWRIIUBXsZOXflsGLA+7d4YCc0@ifi.uio.no>
 <fa.A0XBTh7eCfsh11d3AhMO71/4xQU@ifi.uio.no>
 <fa.fCm35VohC2wt9vlkg94Ru7me4ic@ifi.uio.no>
 <fa.qDqCne4pXntL0PolSS2j8t4py3g@ifi.uio.no>
 <fa.8TboLRab6f7zzIWFr/JPM6q04Zo@ifi.uio.no>
 <fa.PMqnzxUBiShkWV4h9SiztNIwYc0@ifi.uio.no> <45DBBFE8.5080901@shaw.ca>
 <0c69abe94bbc69f652831a64ad77d0cb@digium.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Fredrickson wrote:
> 
> On Feb 20, 2007, at 9:43 PM, Robert Hancock wrote:
> 
>> Matthew Fredrickson wrote:
>>> I have noticed something that might be related as well.  I am working 
>>> on a device driver that would have periodic data errors due to 
>>> exceptionally long interrupt handling latency.  I have come to the 
>>> point that I suspect that it's the sata_nv driver, and now that we 
>>> can't do the hdparm -u1 option for sata, it seems to be a bigger 
>>> problem.
>>
>> What kernel are you using? There were some complaints about latency 
>> problems (the ATA status register read taking a ridiculous amount of 
>> time to complete) on sata_nv previously, but 2.6.20 should eliminate 
>> that problem at least on nForce4 chipsets..
>>
> 
> It's a 2.6.18 kernel.  What we're seeing (by means of the interrupt pin 
> on another card) is extremely large interrupt latency (measured from the 
> time the interrupt pin goes low to the first couple lines of code in the 
> IRQ handler to clear it) occasionally, in the order of 500-700 
> microseconds.  I figured it was some other driver on the system 
> disabling irqs for a long period of time, but it's difficult to trace 
> what might be doing that.

There were reports that an read of the interrupt status register on the 
sata_nv controller could take a huge amount of time (something like 14 
milliseconds as I recall). I don't think it was ever really established 
what was causing that big delay (there was speculation it was trapping 
into SMM mode, but Nvidia denied that one).

In 2.6.20 kernels we use a different operating mode, ADMA, on the 
nForce4 chipsets which usually avoids using that register.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

