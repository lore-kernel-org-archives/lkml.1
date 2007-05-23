Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXEWXQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXEWXQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXEWXQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:16:29 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:9409 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXEWXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:16:29 -0400
Date: Wed, 23 May 2007 17:15:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <200705231611.18944.jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       galibert@pobox.com, linux-kernel@vger.kernel.org, ak@suse.de,
       cebbert@redhat.com, lenb@kernel.org
Message-id: <4654CB1E.3070409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <alpine.LFD.0.98.0705231444200.3890@woody.linux-foundation.org>
 <alpine.LFD.0.98.0705231514410.3890@woody.linux-foundation.org>
 <20070523.160415.26274543.davem@davemloft.net>
 <200705231611.18944.jbarnes@virtuousgeek.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wednesday, May 23, 2007 4:04 pm David Miller wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Wed, 23 May 2007 15:16:23 -0700 (PDT)
>>
>>> That crap should be seen for the crap it is! Dammit, how hard can
>>> it be to just admit that mmconfig isn't that great?
>> I knew mmconfig was broken conceptually the first time I started
>> seeing write posting "bug fixes" for it that would do a read back
>> from PCI config space via mmconfig to post the write, which of course
>> has potential side-effects on the device and is absolutely illegal if
>> the write just performed put the device into a PM state or whatever.
> 
> I've actually seen that specific form of posted write flushing cause 
> crashes on some machines, so yes, it sucks.
> 
> Unfortunately, I don't think we have any other way of getting at 
> extended config space on x86, unless EFI provides methods or something, 
> but I'm not sure that would be an improvement...

That "fix" shouldn't be needed at all, the MMCONFIG memory range 
shouldn't be covered by PCI ordering rules, so there should be no such 
thing as write posting. I suspect that the author of such patch(es) was 
doing so out of some misguided sense that it was needed. (And if there 
is some chipset where it is actually needed, better just disable 
MMCONFIG on that one, as there's no way to use it sanely.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
