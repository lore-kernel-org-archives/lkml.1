Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZAXIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZAXIh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZAXIhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:37:17 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:26437 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZAXIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:37:16 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=O4eYzEeveOXS32gHZIwA:9 a=sc_ph1D9TtWrDFxjJUsiBdpj4RcA:4
Message-ID: <497AD339.2030602@shaw.ca>
Date: Sat, 24 Jan 2009 02:37:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: ronis@ronispc.chem.mcgill.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: Memory not being reported
References: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
In-Reply-To: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ronis wrote:
> I'm running 2.6.28.1 on an i686 (slackware-12.1 for the most part) box.
> I recently added some extra memory, expanding from 2Gb to 4.  Everything
> works as expected except that not all of the memory seems to be seen.
> 
> free returns:
> 
>              total       used       free     shared    buffers
> cached
> Mem:       3374860    2099504    1275356          0      86612
> 1032024
> -/+ buffers/cache:     980868    2393992
> Swap:       497972          0     497972
> 
> 
> and cat /proc/meminfo gives:
> 
> MemTotal:        3374860 kB
> MemFree:         1199184 kB
> Buffers:           86816 kB
> Cached:          1036240 kB
> SwapCached:            0 kB
> Active:          1375864 kB
> 
> etc.
> 
> On the other hand, user-space tools like lshw show the 4 1Gb DIMMS as
> does the BIOS configuration boot menu.
> 
> One suspicion is that the configure option CONFIG_HIGHMEM4G=y
> should be unset and the CONFIG_HIGHMEM64G  should be.

Yes, it should be. However, if your chipset doesn't support remapping 
memory above the 4GB mark (some don't, and this is needed in this case 
because various IO areas use up some of the address space below 4GB) 
then it won't be possible to make use of any of that RAM.

Note that when running with more than 4GB of RAM it's generally 
preferable to run a 64-bit kernel if the machine supports it.

> 
> Any help would be appreciated, as would a separate CC since I don't
> subscribe to the list.
> 
> Thanks in advance
> 
> David
> 

