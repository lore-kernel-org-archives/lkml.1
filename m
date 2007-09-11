Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXIKBpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXIKBpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761190AbXIKBpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:45:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21923 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760620AbXIKBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:44:59 -0400
Date: Mon, 10 Sep 2007 19:44:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI: Unable to reserve mem region problem
In-reply-to: <fa.xf8XcHy8Nla3C3Q0MmArV00z04k@ifi.uio.no>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Karl Bellve <Karl.Bellve@umassmed.edu>, linux-kernel@vger.kernel.org
Message-id: <46E5F300.20602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.kIR1dSmxlPM+uRVmi9kPkHkX/W8@ifi.uio.no>
 <fa.mWCFmDlYQmMO/aBFdKFbo8OVII4@ifi.uio.no>
 <fa.xf8XcHy8Nla3C3Q0MmArV00z04k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 09/05/2007 08:31 PM, Alan Cox wrote:
>> On Wed, 05 Sep 2007 10:32:38 -0400
>> "Karl Bellve" <Karl.Bellve@umassmed.edu> wrote:
>>
>>> Please CC any response. Thanks.
>>>
>>> I am having an issue with a Supermicro h8dce motherboard and failure to 
>>> recognize a 5th SATA drive after upgrading to Fedora 7.
>> Can you send me an lspci -vvxxx so that I can look into this. Might be a
>> few days with the kernel summit but it should give a clue and may be
>> linked to ADMA mode
> 
> It's in RH bugzilla:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=280641

The last BAR on the nForce4 ADMA controllers on this board are at 
0xdfefe000 and 0xdfefd000. But it looks like PnP ACPI is also reserving 
those memory ranges:

Aug 30 14:08:02 alcor kernel: pnp: 00:09: iomem range 
0xdfefd000-0xdfefd3ff has been reserved
Aug 30 14:08:02 alcor kernel: pnp: 00:09: iomem range 
0xdfefe000-0xdfefe3ff has been reserved

Which I very much doubt it should be doing, the BIOS doesn't need to 
reserve PCI BAR ranges in the ACPI tables. This sounds like a BIOS bug. 
You might want to check for an update from Supermicro.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

