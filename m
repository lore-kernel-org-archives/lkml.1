Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXBWAQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXBWAQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXBWAQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:16:13 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53619 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXBWAQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:16:11 -0500
Date: Thu, 22 Feb 2007 18:15:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ACPI driver support for pata
In-reply-to: <20070222182939.56d43a68@lxorguk.ukuu.org.uk>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-kernel@vger.kernel.org
Message-id: <45DE3207.6020707@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
 <45DD2E12.6000705@shaw.ca> <45DD3F20.7050907@pobox.com>
 <20070222142439.50cff3e9@lxorguk.ukuu.org.uk> <45DDCEC4.7050208@garzik.org>
 <20070222182939.56d43a68@lxorguk.ukuu.org.uk>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> On Thu, 22 Feb 2007 12:11:32 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Alan wrote:
>>> ACPI is the only way to do cable handling on the Nvidia PATA chipset. The
>> You failed to quote the salient part of the message.  Disliking a 
>> separate pata_acpi driver in no way invalidates your statement (quoted 
>> above).
> 
> If you drive a device by the ACPI interface you don't get to fiddle with
> it directly or you end up in a murky world of undefined and ungood
> behaviour. Testing and vendor information both say pata_acpi is the right
> way to drive Nvidia PATA ports.

Couldn't be do this generically inside libata core somehow, i.e. try to 
use ACPI to set the proper mode and fall back to the driver-specific 
mode setting code if that didn't work? I think if we could do that it 
would solve a number of problems (i.e. we could prevent it from doing 
this on SATA controllers which appear to be IDE based on the PCI ID, 
like the NVIDIA SATA controllers, since the _GTM and _STM methods seem 
to have undefined behavior on SATA). This would also eliminate the need 
for mkinitrd, people, etc. to know that they're supposed to be loading 
this other pata_acpi driver instead, since any PATA driver could take 
advantage of this feature.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

