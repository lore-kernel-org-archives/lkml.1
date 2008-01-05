Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYAECqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYAECqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 21:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYAECqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 21:46:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbYAECqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 21:46:07 -0500
Message-ID: <477EEF64.6030105@zytor.com>
Date: Fri, 04 Jan 2008 18:45:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Querying the bios from booted linux kernel?
References: <200801041913.54030.gene.heskett@gmail.com>	<477ED3B5.7070009@zytor.com> <20080105021449.2af7a429@lxorguk.ukuu.org.uk>
In-Reply-To: <20080105021449.2af7a429@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Unfortunately, it is not trivial to produce a mapping from EDD data to 
>> real-life disks.  Your best bet is if the disks have an MBR signature, 
> 
> Untrue for all but the very earliest EDD. True for our kernel support
> which wants improving some day
> 
>> in which case the EDD code will capture those; you can then correlate 
>> them to real disks.
> 
> EDD 1 provides the I/O base of each BIOS device so you can cross corelate
> at least each IDE device with the BIOS identifier. EDD 3 provides paths
> in multiple forms including PCI identifiers which serve the same purpose.
> 
> Unfortunately our EDD boot code doesn't capture the right bits in all
> these cases.

That's true for IDE, definitely, but for other drive technologies the 
information can be ether inadequate or downright misleading... 
especially when dealing with complex disk topologies.  Worse, as one 
could expect, the information provided is downright wrong in many cases.

To make matters worse, the EDD standard doesn't have a maintainer, so 
new technologies aren't assigned new identifier.

What you'd want is a way to query the disk serial number, but EDD 
doesn't provide that (there is the "packet interface", but it doesn't 
seem to be widely implemented.)

	-hpa
