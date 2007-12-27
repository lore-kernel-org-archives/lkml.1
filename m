Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXL0SPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXL0SPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXL0SPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:15:33 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5119 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXL0SPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:15:32 -0500
Date: Thu, 27 Dec 2007 12:15:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-reply-to: <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Message-id: <4773EBB4.2020805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 27 Dec 2007, Jeff Garzik wrote:
>> 2) [non-minor] hmmmm.
>>
>> 	[jgarzik@core ~]$ lspci -n | wc -l
>> 	23
>>
>> So I would have to perform 23 sysfs twiddles, before I could obtain a full and
>> unabridged 'lspci -vvvxxx'?
> 
> Or you force it on with "pci=mmconfig" or something at boot-time.
> 
> But yes. The *fact* is that MMCONFIG has not just been globally broken, 
> but broken on a per-device basis. I don't know why (and quite frankly, I 
> doubt anybody does), but the PCI device ID corruption happened only for a 
> specific set of devices.
> 
> Whether it was a timing issue with particular devices or whether it was a 
> timing issue with some particular bridge (and could affect any devices 
> behind that bridge), who knows... It almost certainly was brought on by a 
> borderline (or broken) northbridge, but it apparently only affected 
> specific devices - which makes me suspect that it wasn't *entirely* due to 
> just the northbridge, and it was a combination of things.

Pointer to such a report? The only single-device problems I'm aware of
are with some devices within the K8 integrated northbridge, which we
already handle. Other than that, the only non-global problems I'm aware
of are devices behind host bridges which can't receive/handle MMCONFIG
requests, in which case the problem would be bus-wide.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



