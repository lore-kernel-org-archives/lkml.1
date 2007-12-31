Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXLaBlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXLaBlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXLaBlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:41:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXLaBln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:41:43 -0500
Message-ID: <47784882.9050606@zytor.com>
Date: Sun, 30 Dec 2007 17:40:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Islam Amer <pharon@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <200712301810.59790.juergen127@kreuzholzen.de> <47780480.7060701@zytor.com> <47783FFD.3070302@reed.com>
In-Reply-To: <47783FFD.3070302@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> 
> 
> H. Peter Anvin wrote:
>> Now, I think there is a specific reason to believe that EGA/VGA (but 
>> perhaps not CGA/MDA) didn't need these kinds of hacks: the video cards 
>> of the day was touched, directly, by an interminable number of DOS 
>> applications.  CGA/MDA generally *were not*, due to the unsynchronized 
>> memory of the original versions (writing could cause snow), so most 
>> applications tended to fall back to using the BIOS access methods for 
>> CGA and MDA.
>>
> A little history... not that it really matters, but some might be 
> interested in a 55-year-old hacker's sentimental recollections...As 
> someone who actually wrote drivers for CGA and MDA on the original IBM 
> PC, I can tell you that back to back I/O *port* writes and reads were 
> perfectly fine.  The "snow" problem had nothing to do with I/O ports.  
> It had to do with the memory on the CGA adapter card not being dual 
> ported, and in high-res (80x25) character mode (only!) a CPU read or 
> write access caused a read of the adapter memory by the 
> character-generator to fail, causing one character-position of the 
> current scanline being output to get all random bits, which was then put 
> through the character-generator and generated whatever the character 
> generator did with 8 random bits of character or attributes as an index 
> into the character generator's font table.
> 

[Additional history snipped]

This is all true of course (and a useful history lesson to those not 
familiar with it) but what I wrote above is still true: due to the lack 
of synchronized memory (it doesn't have to be dual-ported, just 
synchronized, if it has enough bandwidth), most DOS applications *in the 
i386+ timeframe* just invoked the BIOS rather than dealing with the 
synchronization needs themselves (anything compiled with a Borland 
compiler using their conio library, for example.)

Hence the variety of software that poked directly at CGA/MDA as opposed 
to EGA/VGA was smaller, but I never claimed it was uncommon.

	-hpa


