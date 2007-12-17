Return-Path: <linux-kernel-owner+w=401wt.eu-S934160AbXLQA6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbXLQA6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbXLQA6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:58:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5170 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992AbXLQA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:58:23 -0500
Date: Sun, 16 Dec 2007 18:57:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
In-reply-to: <fa.jU9nntHcOIpTOJuwui+u+/gya4Y@ifi.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Message-id: <4765C97B.3000305@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.F/CPALGk5eBe3QDRN7pjalMH5m4@ifi.uio.no>
 <fa.56LRmmk2ZdofP2s+juNK5l0iREQ@ifi.uio.no>
 <fa.FRcgZwrZusfLF5d88S6yPr2bvYo@ifi.uio.no>
 <fa.eZe9IlwlTeEF/5eA+8kKfNUncS4@ifi.uio.no>
 <fa.EBJleK5JYl+P/h3+2m6zPq3PzDc@ifi.uio.no>
 <fa.jU9nntHcOIpTOJuwui+u+/gya4Y@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Pavel Machek wrote:
>>>> this is also something for v2.6.24 merging.
>>> As much as I like this patch, I do not think it is suitable for
>>> .24. Too risky, I'd say.
>>>
>> No kidding!  We're talking about removing a hack that has been 
>> successful on thousands of pieces of hardware over 15 years because it 
>                                                              ^----[*]
>> breaks ONE machine.
> 
> [*] "- none of which needs it anymore -"
> 
> there, fixed it for you ;-)
> 
> So lets keep this in perspective: this is a hack that only helps on a 
> very low number of systems. (the PIT of one PII era chipset is known to 
> be affected)
> 
> unfortunately this hack's side-effects are mis-used by an unknown number 
> of drivers to mask PCI posting bugs. We want to figure out those bugs 
> (safely and carefully) and we want to remove this hack from modern 
> machines that dont need it. Doing anything else would be superstition.

Are there any such examples known of such drivers? It doesn't seem to 
make much sense.. PCI IO writes are not posted on any known system (the 
spec allows them to be posted in the host bus bridge, but if they were 
they could only be flushed by a read, not a write) and PCI MMIO writes 
are only guaranteed to flush by doing a read from that device, not by 
other random port accesses. I suppose using the _p versions of port 
accesses might happen to mask such problems on certain machines..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

