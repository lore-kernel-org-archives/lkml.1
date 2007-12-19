Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbXLSALi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbXLSALi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXLSALa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:11:30 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31165 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXLSAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:11:29 -0500
Date: Tue, 18 Dec 2007 18:11:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI resource problems caused by improper address rounding
In-reply-to: <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Message-id: <47686197.6080807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.WmGIH8th8MfmciABVSBi6whxeFE@ifi.uio.no>
 <fa.Obg5E3fyax+MaF94//uo40q/Zyk@ifi.uio.no>
 <fa./6K5nXEIpws4VU8HtJhQjF4AoGg@ifi.uio.no>
 <fa.V82IIxMkW3eu+9B44NfoyYYQDP4@ifi.uio.no>
 <fa.DM9AyNQQtam66XpKVeXeqS639os@ifi.uio.no>
 <fa.f5O3U527Rv8DNk05hDFRjdCaeFE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 18 Dec 2007, Richard Henderson wrote:
>> I've added dmesg, /proc/iomem, and lspci -v output to that bug.
>>
>> Basically, we have
>>
>> 	c0000000-cfffffff : free
>> 	ddf00000-dfefffff : PCI Bus #04
>> 	e0000000-efffffff : pnp 00:0b
>> 	f0000000-fedfffff : less than 256MB
> 
> Gaah. 
> 
> That really is very unlucky. That 256M only goes at one point in the low 
> 4GB, but the thing is, it fits perfectly well above it, and dammit, that 
> resource is explicitly a 64-bit resource or a really good reason. 
> 
> However, I wonder about that
> 
> 	e0000000-efffffff : pnp 00:0b
> 
> thing. I actually suspect that that whole allocation is literally *meant* 
> for that 256MB graphics aperture, but the kernel explicitly avoids it 
> because it's listed in the PnP tables.

That is probably the MMCONFIG aperture, in that case any attempt to map 
the graphics BAR there will have disastrous results. (This BIOS has an 
MCFG table, though it looks like this Fedora kernel has MMCONFIG 
disabled, so we can't tell what it actually contains.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

