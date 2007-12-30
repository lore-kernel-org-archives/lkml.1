Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXL3UxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXL3UxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXL3UxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:53:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXL3UxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:53:16 -0500
Message-ID: <47780480.7060701@zytor.com>
Date: Sun, 30 Dec 2007 12:50:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Juergen Beisert <juergen127@kreuzholzen.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <200712301810.59790.juergen127@kreuzholzen.de>
In-Reply-To: <200712301810.59790.juergen127@kreuzholzen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert wrote:
> On Sunday 30 December 2007 16:38, Alan Cox wrote:
>>> do you have any memories about the outb_p() use of misc_32.c:
>>>
>>>         pos = (x + cols * y) * 2;       /* Update cursor position */
>>>         outb_p(14, vidport);
>>>         outb_p(0xff & (pos >> 9), vidport+1);
>>>         outb_p(15, vidport);
>>>         outb_p(0xff & (pos >> 1), vidport+1);
>>>
>>> was this ever needed? This is so early in the bootup that can we cannot
>> None - but we don't care.
> 
> Was this embedded outb to 0x80 for delay only? Maybe I'm wrong. But in the 
> case above it forces the chipselect signal to deselect the hardware between 
> the access to vidport and vidport+1. Some devices need this to latch the 
> values correctly. Otherwise the chipselect signal would be active for all 
> four accesses in the example above (and only data and addresses are changing 
> from device's view).
> 

Presumably you're talking about an actual ISA bus here.  On those, you 
don't really have a chip select; but you'd expect the latch to happen on 
the rising edge of IOW#, not on an internally generated chip select.

Now, I think there is a specific reason to believe that EGA/VGA (but 
perhaps not CGA/MDA) didn't need these kinds of hacks: the video cards 
of the day was touched, directly, by an interminable number of DOS 
applications.  CGA/MDA generally *were not*, due to the unsynchronized 
memory of the original versions (writing could cause snow), so most 
applications tended to fall back to using the BIOS access methods for 
CGA and MDA.

	-hpa
