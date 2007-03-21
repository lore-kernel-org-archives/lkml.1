Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbXCUXZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbXCUXZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXCUXZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:25:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:44086 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbXCUXZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:25:08 -0400
Date: Wed, 21 Mar 2007 17:21:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] I/O space boot parameter
In-reply-to: <fa.YYUCGI1tr2Apb+hF3LEwyIhLDPM@ifi.uio.no>
To: Daniel Yeisley <dan.yeisley@unisys.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>
Message-id: <4601BE13.1080500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GB583YHCocLIeymeVam9mpGF9CI@ifi.uio.no>
 <fa.QhX1j7epBXZBOc8pKi+Kk+1Ry2o@ifi.uio.no>
 <fa.236bWOhrGT0j4UCxsmp32/n8NCo@ifi.uio.no>
 <fa.5exuGSZI65YO9pz/5yzd/gtgBJI@ifi.uio.no>
 <fa.YYUCGI1tr2Apb+hF3LEwyIhLDPM@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Yeisley wrote:
>> Ah.  Others are working on providing a fix for this too, but it is being
>> done in the drivers themselves, not in the pci core.  Look in the
>> linux-pci mailing list archives for those patches (I don't think they
>> every went into mainline for some reason, but I might be wrong...)
>>
>> I suggest you work with those developers, as they have the same issue
>> that you are trying to solve here.
>>
> 
> I have seen some patches that make the drivers I/O port free here:
> http://lkml.org/lkml/2006/2/26/261
> 
> I checked and they still aren't in the mainline.  
> 
> I don't know that it matters though because I see all the disks attached
> to the system regardless of whether or not the adapters get I/O space.
> The real issue I have is with all the error messages I get at boot.  I
> see 40+ messages that say "PCI: Failed to allocate I/O
> resource..." (from setup-res.c) when the kernel tries to allocate the
> I/O space and can't.  The modules load fine.  I see all the disks just
> fine.  But that many error messages tends to raise concerns and causes
> support calls from customers.

I don't think this can be handled entirely at the driver level. Assuming 
that the IO regions get allocated at bootup, and there's not enough 
space for all devices' IO space to fit, there's no guarantee that the 
ones that didn't fit are the ones where using the IO space is optional, 
and so you could end up with some broken devices.

I suppose you could handle this by assigning the devices who had no 
space assigned by the BIOS last, so that we wouldn't try to assign those 
until we'd already assigned everything else..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

