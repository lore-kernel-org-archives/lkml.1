Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXLSAUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXLSAUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXLSAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:20:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:26763 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbXLSAUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:20:34 -0500
Date: Tue, 18 Dec 2007 18:18:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI resource problems caused by improper address rounding
In-reply-to: <fa.0UHHdYi5zqyJ2xOPhNk/BhJkxYM@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Richard Henderson <rth@twiddle.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Message-id: <47686360.1010208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no>
 <fa.V82IIxMkW3eu+9B44NfoyYYQDP4@ifi.uio.no>
 <fa.DM9AyNQQtam66XpKVeXeqS639os@ifi.uio.no>
 <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no>
 <fa.PJGSMm4TIW6lRYng/jDqooIvj8U@ifi.uio.no>
 <fa.0UHHdYi5zqyJ2xOPhNk/BhJkxYM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 18 Dec 2007, Chuck Ebbert wrote:
> 
>> On 12/18/2007 04:09 PM, Linus Torvalds wrote:
>>> I wonder what the heck is the point of that pnp entry. Just for fun, can 
>>> you try to just disable CONFIG_PNP, and see if it all works then?
>> pnpacpi=off should work.
>>
>> PnP is also trying (and failing) to reserve all physical memory.
> 
> Yeah, that really is a pretty confused-looking pnp table thing. But I have 
> absolutely zero idea how PnP is even supposed to work - the whole thing is 
> just a total hack for Windows, afaik.
> 
> The sad part is that *normally* the right thing to do about almost any 
> BIOS information is what we do right now: just avoid that magic address 
> range like the plague, because we have no clue what the heck the BIOS is 
> up to. But it looks like in this particular case, some of the problems 
> may arise exactly *because* we avoid that range.
> 
> It would be good to know what Windows does. If ACPI is found, does it 
> perhaps just ignore all the PnP entries these days?
> 
> 			Linus

ACPI is where those PnP entries are coming from (on any modern system 
anyway). They do show up in Device Manager as devices with resources 
(the one that reserves all of system RAM on my machine is labeled 
"System board", others like the one that reserves the MMCONFIG aperature 
are "Motherboard resources" - the name is based on the PNP device ID, I 
believe).

It could be that Windows is stupid enough that it will map things over 
top of physical RAM if the BIOS doesn't explicitly reserve it like that. 
  I suspect based on some comments in Microsoft documents that Windows 
uses the E820 table to figure out where the RAM is, and ACPI/PnP 
information to figure out where IO mappings are, but may not really 
combine those two pieces of information into one overall map like Linux 
does, which would explain why it needs to reserve all physical RAM..

(As mentioned in another post, I would guess the BIOS is reserving that 
memory range since it's the MMCONFIG aperture..)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

