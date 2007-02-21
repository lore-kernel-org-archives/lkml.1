Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbXBUP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbXBUP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXBUP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:28:29 -0500
Received: from heineken.digium.com ([216.207.245.2]:60432 "EHLO
	heineken.digium.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXBUP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:28:28 -0500
In-Reply-To: <45DBBFE8.5080901@shaw.ca>
References: <fa.1OWRIIUBXsZOXflsGLA+7d4YCc0@ifi.uio.no> <fa.A0XBTh7eCfsh11d3AhMO71/4xQU@ifi.uio.no> <fa.fCm35VohC2wt9vlkg94Ru7me4ic@ifi.uio.no> <fa.qDqCne4pXntL0PolSS2j8t4py3g@ifi.uio.no> <fa.8TboLRab6f7zzIWFr/JPM6q04Zo@ifi.uio.no> <fa.PMqnzxUBiShkWV4h9SiztNIwYc0@ifi.uio.no> <45DBBFE8.5080901@shaw.ca>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <0c69abe94bbc69f652831a64ad77d0cb@digium.com>
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
From: Matthew Fredrickson <creslin@digium.com>
Subject: Re: High CPU usage with sata_nv
Date: Wed, 21 Feb 2007 09:28:17 -0600
To: Robert Hancock <hancockr@shaw.ca>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2007, at 9:43 PM, Robert Hancock wrote:

> Matthew Fredrickson wrote:
>> I have noticed something that might be related as well.  I am working 
>> on a device driver that would have periodic data errors due to 
>> exceptionally long interrupt handling latency.  I have come to the 
>> point that I suspect that it's the sata_nv driver, and now that we 
>> can't do the hdparm -u1 option for sata, it seems to be a bigger 
>> problem.
>
> What kernel are you using? There were some complaints about latency 
> problems (the ATA status register read taking a ridiculous amount of 
> time to complete) on sata_nv previously, but 2.6.20 should eliminate 
> that problem at least on nForce4 chipsets..
>

It's a 2.6.18 kernel.  What we're seeing (by means of the interrupt pin 
on another card) is extremely large interrupt latency (measured from 
the time the interrupt pin goes low to the first couple lines of code 
in the IRQ handler to clear it) occasionally, in the order of 500-700 
microseconds.  I figured it was some other driver on the system 
disabling irqs for a long period of time, but it's difficult to trace 
what might be doing that.

Matthew Fredrickson

