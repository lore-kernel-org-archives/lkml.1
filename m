Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYHEGgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYHEGgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYHEGgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:36:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:51441 "EHLO
	pd3mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619AbYHEGgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:36:13 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=0vsM53qVS1T-vwDA2z4A:9 a=mo2he-yKa2G-3bl01ygA:7 a=tBAaBIARhujYrnGPm_OZZG9RW7IA:4 a=UrG_RJUhHJwA:10
Message-ID: <4897F4DA.1070408@shaw.ca>
Date: Tue, 05 Aug 2008 00:36:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linasvepstas@gmail.com
CC: John Stoffel <john@stoffel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
References: <fa.qB5d+HsAJ6G05jNoeU8Q9GV6Dow@ifi.uio.no> <fa.fxlDAHxOnGgcBiOH/EOauE67ZPc@ifi.uio.no> <fa.1WYUmN6FHR5yW+sXoYRFN22Y8S8@ifi.uio.no> <fa.LAUkvEUlYiF69V/F8F3wigxqH9w@ifi.uio.no> <fa.mXeFXYNkfZfUYPQcGwzok0IOIfY@ifi.uio.no> <fa.KjbvCGbUr2JeQTcwA1/sFGIIMik@ifi.uio.no> <489675DC.2080906@shaw.ca> <3ae3aa420808042229l675ffd79p42a5691532b7ac3b@mail.gmail.com>
In-Reply-To: <3ae3aa420808042229l675ffd79p42a5691532b7ac3b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> 2008/8/3 Robert Hancock <hancockr@shaw.ca>:
>> Linas Vepstas wrote:
>>> What I don't like is that the corruption was utterly silent --
> [...]
>>> So the question is: is there some sort of sata (or pci) "loopback mode",
>>> where we could pump data through all of the busses and controllers, up
>>> near to the point where it would normally go out to the serdes to the
>>> disk,
>>> but instead have it loop back, so that we could test the buses between
>>> endpoints?
>> I don't imagine that would be very useful in this case. The SATA link, PCI
>> Express bus, HyperTransport bus all have parity or CRC error checking, so
>> presumably they couldn't be likely to cause undetected errors. The
>> transitions between them could cause problems,
> 
> Well, but I suffered badly from an undetected error, in the sense
> that the operating system had no knowledge of it, and it corrupted
> data on disk as a result. As Alan Cox suggests, perhaps I didn't
> have EDAC turned on, or something ... I'm investigating now.
> But this is moot -- if there is software that already exists that
> could have reported the error to the kernel, then this software
> should have been installed/enabled/operating by default.

EDAC is mainly useful for detecting non-fatal problems (i.e. things like 
  corrupted transfers that were detected and retried, or ECC errors that 
could be corrected) which might indicate a problem but might go 
unnoticed otherwise. Usually, fatal problems that get detected by 
hardware wouldn't be unnoticeable - they would typically raise NMIs and 
cause funny kernel messages, cause machine check exceptions or just lock 
up or reset the machine.

Of course, if you don't have ECC memory, and you have bad RAM or memory 
timing problems, nothing can detect this at all, and EDAC wouldn't help you.

> 
>> and most desktop machines
>> don't have ECC memory which could catch memory timing problems or bad RAM
> 
> I'm unclear on ECC memory: if a motherboard "supports ECC",
> does it mean it actually uses ECC bits in the bus between the
> memory controller and the RAM?  Or does it simply mean that
> it won't hang if I plug in ECC RAM (but otherwise ignore the bits)?

I think just about all chipsets (more specifically, memory controllers, 
this includes AMD CPUs) support ECC and use the bits, at least if all 
the installed memory supports it. I've never heard of a board that 
couldn't handle ECC at all.

> 
> Personally I'm ready to pop $$$ for ECC it if will actually do
> something for me, this has been painful.
> 
> --linas
> 
