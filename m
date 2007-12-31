Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXLaA0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXLaA0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXLaA0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:26:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbXLaA0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:26:16 -0500
Message-ID: <47783678.9070706@zytor.com>
Date: Sun, 30 Dec 2007 16:23:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl>	<20071230183927.5a5a3c42@the-village.bc.nu>	<4777F297.9070207@keyaccess.nl>	<alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>	<47780B93.4050606@reed.com> <20071230213623.410d480a@the-village.bc.nu> <4778266B.2060502@reed.com>
In-Reply-To: <4778266B.2060502@reed.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> Alan Cox wrote:
>>> Now what's interesting is that the outb to port 80 is *faster* than 
>>> an outb to an unused port, on my machine.  So there's something there 
>>> - actually accepting the bus transaction.   In the ancient 5150 PC, 
>>> 80 was     
>>
>> Yes and I even told you a while back how to verify where it is. From the
>> timing you get its not on the LPC bus but chipset core so pretty
>> certainly an SMM trap as other systems with the same chipset don't have
>> the bug. Probably all that is needed is a BIOS upgrade
>>
>>   
> Actually, I could see whether it was SMM trapping due to AMD MSR's that 
> would allow such trapping, performance or debug registers.  Nothing was 
> set to trap with SMI or other traps on any port outputs.   But I'm 
> continuing to investigate for a cause.  It would be nice if it were a 
> BIOS-fixable problem.  It would be even nicer if the BIOS were GPL...

If it was an SMM trap, I would expect it to be trapped in the SuperIO chip.

	-hpa
