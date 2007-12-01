Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXLAAeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXLAAeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXLAAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:33:50 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:56179 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbXLAAds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:33:48 -0500
Message-ID: <4750ABCB.6090705@keyaccess.nl>
Date: Sat, 01 Dec 2007 01:33:15 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
References: <1196442277.23251.318.camel@queen.suse.de> <47509EB6.20300@keyaccess.nl> <200711301652.42110.bjorn.helgaas@hp.com>
In-Reply-To: <200711301652.42110.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-12-07 00:52, Bjorn Helgaas wrote:

> On Friday 30 November 2007 04:37:26 pm Rene Herman wrote:
>> On 30-11-07 18:04, Thomas Renninger wrote:
>>> If I have not overseen something, it should be rather obvious that those
>>> can all be declared __init...
>>> ---------------
>>>
>>> Declare PNP option parsing functions as __init
>>>
>>> There are three kind of parse functions provided by PNP acpi/bios:
>>>  - get current resources
>>>  - set resources
>>>  - get possible resources
>>> The first two may be needed later at runtime.
>>> The possible resource settings should never change dynamically.
>>> And even if this would make any sense (I doubt it), the current implementation
>>> only parses possible resource settings at early init time:
>>>   -> declare all the option parsing __init
>>>
>>> Signed-off-by: Thomas Renninger <trenn@suse.de>
>> Yes. Obviousness aside,
>>
>> (0) pnpacpi_add_device                          is only caller of
>> ...
> 
> I agree this is probably safe in the current implementation.
> 
> However, I think the current implementation is just broken because
> we can't really handle hotplug of ACPI devices.  Specifically, I think
> the first TBD in acpi_bus_check_device() should be fleshed out so it
> does something like pnpacpi_add_device().
> 
> So my dissenting opinion is that this patch would just get reverted
> soon anyway when somebody finishes implementing ACPI hotplug, and
> therefore it's not worth doing.

<shrug>

The PnPBIOS bits should still be fine at least I guess. And, it would seem 
this is rather essential to Thomas' efforts of making this stuff dynamic in 
the first place anyway. In these threads, Alan Cox (added to CC) earlier 
commented that with required locking when things are quite _that_ dynamic a 
different setup than the one currently on the table seems in order.

I don't know, but small steps may make sense giving that it seems dynamic 
allocation is fairly wanted with the massive number of PnPACPI resources 
people are reporting since the warning about overrunning them was added.

Rene.

