Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYAHU2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYAHU2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYAHU2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:28:37 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:57438 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYAHU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:28:35 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.106
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OUa/w23VnzICq0KD5dgAi
Message-ID: <4783DCD3.8010201@reed.com>
Date: Tue, 08 Jan 2008 15:28:03 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ondrej Zary <linux@rainbow-software.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com> <20080108202519.1057cb75@cw05linux>
In-Reply-To: <20080108202519.1057cb75@cw05linux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christer Weinigel wrote:
>> There is no need to use io writes to supposedly/theoretically "unused 
>> ports" to make drivers work on any bus.
>> ISA included!  You can, for example, wait for an ISA bus serial
>> adapter to put out its next character by looping reading the port
>> that has the output buffer full flag in a tight loop, with no delay
>> code at all.  And if you need to time things, just call a timing loop
>> subroutine that you calibrate at boot time.
>>     
>
> Now you're totally confusing things.  You're talking about looking at
> bits in a register to see if a transmit register is empty.  
> That's easy.
>
> The delays needed for the Intel M8259 and M8253 say that you're not
> even allowed to access the registers _at_ _all_ for some time after a
> register access.  If you do a write to a register immediately followed
> by any access, including a read of the status register, you can corrupt
> the state of the chip.
>   
Not true.  Even on the original IBM 5150 PC, the 8259 on the motherboard 
accepted back to back  OUT and IN instructions, and it would NOT trash 
the chip state.  You can read the original IBM BIOS code if you like.  I 
don't remember about the 8253's timing.  I doubt the chip's state would 
be corrupted in any way. The data and address lines were the same data 
and address lines that the microprocessor used to access memory - it 
didn't "hold" the lines stable any longer than the OUT instruction.
> And the Intel chips are not the only ones with that kind of brain
> damage.  But what makes the 8259 and 8253 a big problem is that every
> modern PC has a descendant of those chips in them.
Register compatible.  Not  the same chips or even the same  masks or 
timing requirements.
> The discrete Intel
> chips or clones got aggregated into Super I/O chips, and the Super I/O
> chips were put on a LPC bus (an ISA bus with another name) or
> integrated into the southbrige.
Don't try to teach your grandmother to suck eggs: I've been programming 
PC compatibles since probably before you were able to do long division - 
including writing code on the first prototype IBM PCs, the first 
pre-manufacturing PC-ATs, and zillions of clones.  (and I was also 
involved in designing hardware including the so-called "Lotus Intel" 
expanded memory cards and the original PC cards)  The 8259 PIC is an 
*interrupt controller*. It was NEVER present in a Super I/O chip, or an 
LPC chip.  Its functionality was absorbed into the chipsets that control 
interrupt mapping, like the PIIX and the nForce. 

> And the "if it ain't broken, don't fix
> it" mantra probably means that some modern chipsets are still using
> exactly the same internal design as the 25 year old chips and will
> still be subject to some of those ancient limitations.
>   
Oh, come on.  Give the VLSI designers some credit for brains.   The CAD 
tools used to design the 8259 and 8253 were so primitive you couldn't 
even get a chip manufactured with designs from that era today.  When 
people design chips today they do it with simulators that can't even 
work, and testers that run from test suites that were not available at 
the time.
